require_relative '../db_spec_helper'

RSpec.describe ArticlesRepo do
  subject(:repo) { ArticlesRepo.new(Persistence.rom) }

  describe '#listing' do

    it 'lists all published articles' do
      Factory[:article]
      Factory[:article]
      Factory[:article, published: false]

      expect(repo.listing.count).to eq 2
    end

    it
  end
end
