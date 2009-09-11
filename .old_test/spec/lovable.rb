require File.join(File.dirname(__FILE__), "setup", "db.rb")

require "nitro/part/content/model/lovable"

context "A Lovable" do

  setup do
    class Article
      is Lovable
      attr_accessor :title, String
      attr_accessor :body, String
      
      def initialize(title, body)
        @title, @body = title, body
      end
    end

    @store = quick_setup(User, Article)
  end

  teardown do
    og_teardown(@store)
  end

  specify "can be loved by users" do
    u = User.new("gmosx")
    u.force_save!
    a = Article.new("Hello", "World")
    a.save!
    
    a2 = Article[1]
    u2 = User[1]

    a2.loved_by(u2)

    b = Article[1]
    b.users.size.should == 1
    b.users.first.name.should == "gmosx"
  end
    
end
