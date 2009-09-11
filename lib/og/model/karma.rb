
# Include karma (rank) functionality in the model. Karma is a
# generalized ranking system.

module Karma
  
  attr_accessor :karma, Fixnum

  before :og_insert do
    @karma = 1
  end
  
end
