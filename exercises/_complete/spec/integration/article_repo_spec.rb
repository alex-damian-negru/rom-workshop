require "db_spec_helper"

RSpec.describe ArticleRepo do
  subject(:repo) { ArticleRepo.new(Persistence.rom) }

  before do
    author = Factory[:author, name: "Jane Doe"]

    Factory[:article, title: "First test article", published: true, author_id: author.id]
    Factory[:article, title: "Draft article", published: false, author_id: author.id]
  end

  describe "#listing" do
    it "returns published articles with authors" do
      articles = repo.listing

      expect(articles.length).to eq 1
      expect(articles.first.title).to eq "First test article"
      expect(articles.first.author.name).to eq "Jane Doe"
    end
  end
end
