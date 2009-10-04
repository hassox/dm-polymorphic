require File.dirname(__FILE__) + "/spec_helper"

DataMapper::Logger.new(STDOUT, :debug)

if HAS_SQLITE3 || HAS_MYSQL || HAS_POSTGRES
  describe "DataMapper::Polymorphic" do
    
    class Comment
      include DataMapper::Resource

      is :polymorphic, :commentable

      property :id,   Serial
      property :text, String
    end

    class Post
      include DataMapper::Resource

      property :id,   Serial
      property :name, String  

      has n, :comments, :polymorphically => :commentable   
    end

    class Article
      include DataMapper::Resource

      property :id,   Serial
      property :name, String  

      has n, :comments, :polymorphically => :commentable
    end
    
    before :each do
      Comment.auto_migrate!
      Post.auto_migrate!
      Article.auto_migrate!
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
        item.reload
        item.comments(:text => "comment2").should have(1).item
      end
      
      it "should access all the comments from the post for #{klass}" do
        item = klass.create(:name => "item3")
        c1 = Comment.new(:text => "comment3")
        c2 = Comment.new(:text => "comment4")
        [c1,c2].each{|c| item.comments << c}
        item.reload
        item.comments.should have(2).items
      end
      
      it "should access the post from the comment for #{klass}" do
        item = klass.create(:name => "item4")
        c = Comment.new(:text => "comment5")
        item.comments << c
        item.save
        c.send(Extlib::Inflection.underscore(klass.name).to_sym).should == item
      end
      
      it "should access the commentable from the comment for #{klass}" do
        item = klass.create(:name => "item5")        
        c = Comment.new(:text => "comment6")
        item.comments << c
        item.reload; c.reload
        c.commentable.should == item
      end
    end
    
    it "should only make one query to each Model" do
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
        puts "COMMENT: #{c.text} - #{c.commentable_class}"
      end
      
      Post.should_receive(:all).once
      # Article.should_receive(:all).once.and_return(Article.comments)
    
      Comment.all.each do |comment|
        [Post, Article].should include(comment.commentable.class)
      end
    end

  end
end

