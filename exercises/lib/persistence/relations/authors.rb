# frozen_string_literal: true

module Persistence
  module Relations
    class Authors < ROM::Relation[:sql]
      schema :authors, infer: true
    end
  end
end
