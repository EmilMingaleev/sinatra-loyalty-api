class User < Sequel::Model(:users)
  one_to_many :operations
end
