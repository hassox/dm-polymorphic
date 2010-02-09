require File.join(File.dirname(__FILE__), "dm-polymorphic")

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, 'sqlite3::memory:')

class Comment
  include DataMapper::Resource
  
  # is :polymorphic, :commentable
  belongs_to :commentable, :polymorphic => true
  
  property :id,   Serial, :serial => true
  property :text, String
end
    
class Post
  include DataMapper::Resource
  
  property :id, Serial, :serial => true
  property :name,  String  

  has n, :comments, :as => :commentable  
  # has n, :comments, :polymorphically => :commentable   
end

class Article
  include DataMapper::Resource
  
  property :id, Serial, :serial => true
  property :name,  String  

  has n, :comments, :as => :commentable  
  # has n, :comments, :polymorphically => :commentable
end

Comment.auto_migrate!
Post.auto_migrate!
Article.auto_migrate!

post1 = Post.create(:name => "post1")
article1 = Article.create(:name => "article1")
post2 = Post.create(:name => "post2")
article2 = Article.create(:name => "article2")
post3 = Post.create(:name => "post3")
article3 = Article.create(:name => "article3")

%w(one two three four five six seven eight nine ten).each_with_index do |text, index|
  [post1, post2, post3, article1, article2, article3].each do |item|
    item.comments << Comment.new(:text => text)
    item.save
  end
end

puts "========================="

Comment.all.each do |c|
  puts "COMMENT: #{c.text} - #{c.commentable.name}"
end