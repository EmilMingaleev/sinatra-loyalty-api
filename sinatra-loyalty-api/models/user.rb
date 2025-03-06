# frozen_string_literal: true

class User < Sequel::Model(:users)
  one_to_many :operations
end
