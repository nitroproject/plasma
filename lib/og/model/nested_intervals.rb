require "facets/string/underscore"
require "facets/string/plural"

module Hierarchical

# A useful encapsulation of the nested intervals pattern for 
# hierarchical SQL queries. Slightly adapted from the original
# article.
#
# References:
#
# * http://www.dbazine.com/tropashko4.shtml)
# * http://www.grzm.com/fornow/archives/2004/07/10/static_hierarchies
# * http://www.sigmod.org/sigmod/record/issues/0506/p47-article-tropashko.pdf
# * http://arxiv.org/html/cs.DB/0401014
#   
# right = x axis
# left = y axis
# s = right + left = num/den
#
# === Example
#
# class Post
#   is Hierarchical::NestedIntervals, :container => :forum
#   ..
# end

module NestedIntervals

  # Node right extremum.

  attr_accessor :ni_rgt, Float, :control => :none

  # Node left extremum.

  attr_accessor :ni_lft, Float, :control => :none

  # Node sum numerator/denominator.
  
  attr_accessor :ni_num, :ni_den, Fixnum, :control => :none

  # ...
  #--
  # TODO: children, tree, etc.
  #++
    
  def descendants
    self.class.all(
      :condition => "(ni_lft >= #@ni_lft) AND (ni_rgt <= #@ni_rgt)",
      :order => "ni_rgt desc"
    ) 
  end

  # Returns the materialized path of this node.
  
  def materialized_path
    Map.path(@ni_num, @ni_den)
  end
  alias tree_path materialized_path
  
  # Returns the depth of this node. The root nodes have a 
  # depth = 0.
  
  def depth
    (Map.path(@ni_num, @ni_den).size - 1)/2
  end

  def self.included_with_parameters(base, options)
    base.module_eval %{
      # This method is called before og_insert to encode the
      # position of this object in the hierarchy acording to the
      # nested intervals algorithm.
      
      def encode_hierarchy
        if parent
          @ni_num, @ni_den = Map.child(parent.ni_num, parent.ni_den, parent.children.count + 1)
        else
          @ni_num, @ni_den = Map.encode_path("\#{#{options[:container]}.#{base.to_s.underscore.plural}.count + 1}")
        end
        
        # Also store left/right for easier calculations.
        
        rnum, rden = Map.right(@ni_num, @ni_den)
        @ni_rgt = Float(rnum) / rden
        lnum, lden = Map.left(@ni_num, @ni_den)
        @ni_lft = Float(lnum) / lden
      end

      before :og_insert, :call => :encode_hierarchy    
    }
  end
    
end

# Nested intervals mapping methods.

class NestedIntervals::Map
  class << self
      
  # Returns the right (x-axis) num/den from the sum num/den.
    
  def right(snum, sden)
    num = snum + 1
    den = sden * 2

    while (num / 2) == (num / 2.0)
      num /= 2
      den /= 2
    end

    return num, den
  end
  alias x right
  
  # Returns the right (x-axis) num/den from the sum num/den.

  def left(snum, sden)
    num, den = right(snum, sden)

    while den < sden
      num *= 2
      den *= 2
    end

    num = snum - num

    while (num / 2) == (num / 2.0)
      num /= 2
      den /= 2
    end

    return num, den
  end
  alias y left
  
  # Returns the parent num/den from the child num/den.
  
  def parent(cnum, cden)
    return nil if cnum == 3

    num = (cnum - 1) / 2
    den = cden / 2
    while ((num-1) / 4) == ((num-1) / 4.0)
      num = (num + 1) / 2
      den = den / 2
    end
    
    return num, den    
  end

  # Returns the child index (position) within the siblings
  # of the childs parent.
  
  def child_index(cnum, cden)
    num = (cnum - 1) / 2
    den = cden / 2
    index = 1
    
    while ((num-1) / 4) == ((num-1) / 4.0)
      return index if num == 1 and den == 1
      num = (num + 1) / 2
      den /= 2
      index += 1
    end
    
    return index
  end
  alias sibling_index child_index
      
  # Returns the child den/num at the given index in the
  # parents children.
  
  def child(pnum, pden, index = 0)
    power = 2 ** index

    num = (pnum * power) + 3 - power
    den = pden * power

    return num, den    
  end

  # Returns a string representation of the path to the given
  # node.
    
  def path(num, den)
    return '' if num == nil

    pnum, pden = parent(num, den)
    if pnum
      return "#{path(pnum, pden)}.#{child_index(num, den)}"
    else
      return "#{child_index(num, den)}"
    end
  end

  # Encode the given path.
  
  def encode_path(path)
    num = den = 1
    postfix = path.dup

    while postfix
      sibling, postfix = postfix.split('.', 2)
      num, den = child(num, den, sibling.to_i)
    end

    return num, den
  end
  alias encode encode_path
  
  # Calculates the distance between two points.
  
  def distance(num1, den1, num2, den2)
  end
  
  end
end

end
