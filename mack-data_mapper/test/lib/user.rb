class User
  include DataMapper::Persistence
  
  property :username, :string
  property :email, :string
end