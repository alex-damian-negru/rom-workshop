require "bundler/setup"
require "pry"
require "rom-repository"

require_relative "setup"

MIGRATION = Persistence.db.migration do
  change do
    create_table :authors do
      primary_key :id
      column :name, :text, null: false
    end

    create_table :articles do
      primary_key :id
      column :title, :text, null: false
      column :published, :boolean, null: false, default: false
      foreign_key :author_id, :authors
    end
  end
end

# TODO: add exercise code here
module Entities
  class Article < ROM::Struct
    require 'dry/types'
    schema do
      attribute :title, Dry::Types['strict.string']
      attribute :published, Dry::Types['strict.boolean']
    end
  end

  class Author < ROM::Struct
    require 'dry/types'
    schema do
      attribute :name, Dry::Types['strict.string']
    end
  end
end

class ArticlesRepo < ROM::Repository[:articles]
  struct_namespace Entities
  commands :create, update: :by_pk

  def by_pk(id)
    articles.by_pk(id).one
  end

  def listing
    articles.published.combine(:author).to_a
  end

  def publish(author, article)
    articles
      .changeset(:create, article)
      .map { |attrs| attrs.merge(published: true) }
      .associate(author)
      .commit
  end

  def unpublish(article)
    articles
      .by_pk(article.id)
      .changeset(:update, article)
      .map { |attrs| attrs.to_h.merge(published: false) }
      .commit
  end
end

class AuthorsRepo < ROM::Repository[:authors]
  struct_namespace Entities
  commands :create
end

if $0 == __FILE__
  # Start with a clean database each time
  Persistence.reset_with_migration(MIGRATION)
  Persistence.finalize

  articles_repo = ArticlesRepo.new(Persistence.rom)
  authors_repo = AuthorsRepo.new(Persistence.rom)

  # TODO: play around here ;)
  author_1 = authors_repo.create(name: 'Dostoievski')
  author_2 = authors_repo.create(name: 'Tolstoi')

  articles_repo.create(title: 'title 1', published: true, author_id: author_1.id)
  articles_repo.create(title: 'title 2', published: true, author_id: author_1.id)
  articles_repo.create(title: 'title 3', published: false, author_id: author_2.id)
  articles_repo.create(title: 'title 4', published: false, author_id: author_2.id)

  articles_repo.update(3, title: 'new title 3')

  binding.pry
end
