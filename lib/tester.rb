require File.join(File.dirname(__FILE__), "dm-polymorphic")

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, 'sqlite3::memory:')

class Comment
  include DataMapper::Resource
  
  is :polymorphic, :commentable
  
  property :id,   Integer, :serial => true
  property :text, String
end
    
class Post
  include DataMapper::Resource
  
  property :id, Integer, :serial => true
  property :name,  String  

  has n, :comments, :polymorphically => :commentable   
end

class Article
  include DataMapper::Resource
  
  property :id, Integer, :serial => true
  property :name,  String  

  has n, :comments, :polymorphically => :commentable
end

Comment.auto_migrate!
Post.auto_migrate!
Article.auto_migrate!

post1 = Post.create(:name => "post1")
article1 = Article.create(:name => "article1")
post2 = Post.create(:name => "post2")
article2 = Article.create(:name => "article2")

%w(one two three four five six seven eight nine ten).each_with_index do |text, index|
  [post1, post2, article1, article2].each do |item|
    item.comments << Comment.new(:text => text)
  end
end

Comment.all.each do |c|
  puts "COMMENT: #{c.text} - #{c.commentable}"
end