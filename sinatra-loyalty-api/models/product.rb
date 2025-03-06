# frozen_string_literal: true

class Product < Sequel::Model(:products)
  one_to_many :operations
end
