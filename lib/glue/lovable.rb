require "glue/karma"

require 'og'

# Add love/hate support to objects. Implicitly includes
# the Karma module.
#--
# Does not require part/id for extra flexibility in defining
# 'User'.
# WARN: user == author == owner.
# THINK: are the excessive saves needed?
#++

module Lovable
  include Og::EntityMixin

  attr_accessor :lovers_count, Fixnum, :control => :none
  attr_accessor :haters_count, Fixnum, :control => :none
  
  many_to_many :lovers, User 
  many_to_many :haters, User
  
  def self.included(base)
    plural = base.to_s.underscore.pluralize
 
    base.send :include, Karma
    base.before :og_insert do 
      @lovers_count = 1
      @haters_count = 0
    end
    
    base.module_eval %{
      def loved_by(lover)
        unless lover.loved_#{plural}.include?(self) or (user == lover)
          lover.loved_#{plural} << self
          lover.save
          
          @lovers_count += 1
          self.increase_karma_by(lover.karma)
          self.save
        end
      end

      def hated_by(hater)
        unless hater.hated_#{plural}.include?(self) or (user == hater)
          hater.loved_#{plural} << self
          hater.save
          
          @haters_count += 1
          self.decrease_karma_by(hater.karma)
          self.save
        end
      end
    }
  end

end
