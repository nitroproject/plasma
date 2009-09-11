
# Karma represts how 'good' the owner object is. Each object
# get created with an initial karma equal to 1.

module Karma

  # The karma of this object.
   
  attr_accessor :karma, Fixnum

  def self.included(mod)
    mod.before :og_insert do 
      @karma = 1
    end
  end

  # Pass positive values to increase the karma, negative values
  # to decrease it.
  
  def update_karma_by(delta)
    @karma += delta
    consider_karma()
  end
  alias increase_karma_by update_karma_by
  
  def decrease_karma_by(delta)
    update_karma(-delta)
  end
  
  # Implement this callback in your object to act on 
  # karma changes.
  
  def consider_karma
  end
  
end
