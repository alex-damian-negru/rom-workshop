# frozen_string_literal: true

module Persistence
  module Relations
    class Articles < ROM::Relation[:sql]
      schema :articles, infer: true do
        associations do
          belongs_to :author, combine_key: :author_id
        end
      end

      def published
        where(published: true)
      end
    end
  end
end
