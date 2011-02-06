require File.dirname(__FILE__) + "/spec_helper"

DataMapper::Logger.new(STDOUT, :debug)

describe "DataMapper::Polymorphic" do

  class Comment
    include DataMapper::Resource

    property :id,   Serial
    property :text, String

    belongs_to :commentable, :polymorphic => true
  end

  class Post
    include DataMapper::Resource

    property :id,   Serial
    property :name, String  

    has n, :comments, :as => :commentable
  end

  class Article
    include DataMapper::Resource

    property :id,   Serial
    property :name, String  

    has n, :comments, :as => :commentable
  end

  [Article, Post].each do |klass|
    it "should create an associated object for #{klass}" do
      item = klass.create(:name => "item1")
      item.reload
      item.comments.create(:text => "A Comment")
      item.reload
      item.comments(:text => "A Comment").should have(1).item
    end

    it "should add the comment with the << syntax for #{klass}" do
      item = klass.create(:name => "item2")
      c = Comment.new(:text => "comment2")
      item.comments << c
      c.save
      item.reload
      item.comments(:text => "comment2").should have(1).item
    end

    it "should not add the comment with the << syntax for #{klass} if comment was not saved" do
      item = klass.create(:name => "item2a")      
      c = Comment.new(:text => "comment2a")
      item.comments << c
      item.reload
      item.comments(:text => "comment2a").should have(0).item
    end

    it "should access all the comments from the post for #{klass}" do
      item = klass.create(:name => "item3")
      c1 = Comment.new(:text => "comment3")
      c2 = Comment.new(:text => "comment4")
      [c1,c2].each{|c| item.comments << c}
      item.comments.save
      item.reload
      item.comments.should have(2).items
    end

    it "should access the commentable from the comment for #{klass}" do
      item = klass.create(:name => "item5")        
      c = Comment.new(:text => "comment6")
      item.comments << c
      c.save
      item.reload; c.reload
      c.commentable.should == item
    end
  end

  it "should access the post and article from the comment only if it is a post or article" do
    article = Article.create(:name => "item6")        
    post = Post.create(:name => "item7")
    c1 = Comment.new(:text => "comment6")
    c2 = Comment.new(:text => "comment7")        
    post.comments << c1
    post.save
    article.comments << c2
    article.save
    [post, article, c1, c2].map(&:reload)
    c1.post.should == post
    c1.article.should be_nil
    c2.post.should be_nil
    c2.article.should == article
  end  
    
  # it "should only make one query to each Model" do
  #   post1 = Post.create(:name => "post1")
  #   article1 = Article.create(:name => "article1")
  #   post2 = Post.create(:name => "post2")
  #   article2 = Article.create(:name => "article2")
  #   
  #   %w(one two three four five six seven eight nine ten).each_with_index do |text, index|
  #     [post1, post2, article1, article2].each do |item|
  #       item.comments.create(:text => text)
  #     end
  #   end
  #   
  #   Post.all.each do |c|
  #     puts "COMMENT: #{c.text} - #{c.commentable_class}"
  #   end
  #   
  #   Post.should_receive(:all).once
  #   Article.should_receive(:all).once.and_return(Article.comments)
  #   
  #   Comment.all.each do |comment|
  #     [Post, Article].should include(comment.commentable.class)
  #   end
  # end
    
end

