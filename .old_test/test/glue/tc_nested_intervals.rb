#$DBG = true

require 'test/unit'
require 'og'

require 'glue/nested_intervals'

class Comment
  is Hierarchical::NestedIntervals
  attr_accessor :body, String
  belongs_to :parent, Comment
  has_many :children, Comment, :foreign_name => :parent
  
  def initialize(body = nil, parent = nil)
    @body = body
    self.parent = parent
  end
end

class TC_NestedIntervals < Test::Unit::TestCase # :nodoc: all
  include Og

  def test_mappings
    map = Hierarchical::NestedIntervals::Map

    assert_equal [5, 8], map.right(39, 32)
    assert_equal [19, 32], map.left(39, 32)
        
    assert_equal [3, 2], map.encode_path('1')
    assert_equal [19, 16], map.encode_path('1.3')
    assert_equal [39, 32], map.encode_path('1.3.1')
    assert_equal [27, 32], map.encode_path('2.1.2')
    assert_equal [7, 8], map.encode_path('2.1')
    assert_equal [3, 4], map.encode_path('2')

    assert_equal '2', map.path(3, 4)
    assert_equal '2.1', map.path(7, 8)
    assert_equal '2.1.2', map.path(27, 32)

    assert_equal '1.3.1', map.path(39, 32)
    assert_equal '1', map.path(3, 2)
    
    assert_equal [39, 32], map.child(19, 16, 1)
  end

  def test_all
    $og = Og.setup(
      :destroy => true,
      :adapter => :mysql,
      :name => 'test',
      :user => 'root'
    )

    c1 = Comment.create('1')
      c11 = Comment.create('1.1', c1)
      c12 = Comment.create('1.2', c1)
        c121 = Comment.create('1.2.1', c12)
        c122 = Comment.create('1.2.2', c12)
      c13 = Comment.create('1.3', c1)
        c131 = Comment.create('1.3.1', c13)

    assert_equal 3, c12.descendants.size
=begin
    for c in Comment.all(:order => "ni_rgt desc")
      p c.body
    end

    p '---'
    
    for c in c1.descendants
      p c.body
    end

    p '---'
    
    for c in c12.descendants
      p c.body
    end
=end
  end
  
end
