# frozen_string_literal: true

class Template < Sequel::Model(:templates)
  one_to_many :users
end
