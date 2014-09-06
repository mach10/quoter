class Quote
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required => true
  property :created_at, DateTime
end