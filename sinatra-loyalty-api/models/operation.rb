# frozen_string_literal: true

class Operation < Sequel::Model(:operations)
  many_to_one :user
  many_to_one :product
end
