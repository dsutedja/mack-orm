class Post
  include DataMapper::Persistence
  
  property :user_id, :string
  property :body, :text
end