#$DBG = true

require 'test/unit'
require 'og'

require 'glue/karma'

class Article; end

class User
  include Og::EntityMixin
  include Aspects
  include Karma
    
  attr_accessor :name, String
  
  many_to_many :loved_articles, Article
  many_to_many :hated_articles, Article
  
  def initialize(name)
    @name = name
  end
end

require 'glue/lovable'

class Article
  include Aspects
  include Lovable
  
  attr_accessor :title, String

  belongs_to User
  
  def initialize(title)
    @title = title
  end
end

class TC_Lovable < Test::Unit::TestCase # :nodoc: all

  def test_all
    $og = Og.start(
      :destroy => true,
      :adapter => :mysql,
      :name => 'test',
      :user => 'root'
    )

    u = User.create('gmosx')
    a = Article.create('Hello')

    a.loved_by(u)

    assert_equal 1, a.lovers_count
    assert_equal 1, a.lovers.count    
  end
  
end
