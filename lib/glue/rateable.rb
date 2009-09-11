module Glue
  
# Adds rating support to the base class.
#--
# THINK: Rename this to Rated?
#++

module Rateable

  # The name of the rate cookie.
  
  setting :cookie, :default => 'nrate', :doc => 'The name of the rate cookie'

  # The rating of the object.
  
  property :rating, Float
  
  # The number of ratings.
  
  property :rate_count, Fixnum
  
  # The maximum rating value.
  
  setting :max, :default => 5, :doc => 'The maximum rating value'

  # The minimum rating value.
  
  setting :min, :default => 0, :doc => 'The minimum rating value'

  # Rate this object. The suggested scale 
  # is 0..5
  
  def rate(new_rating, save_object = true)
    new_rating = new_rating.to_i
    if new_rating >= Rateable.min and new_rating <= Rateable.max
      unless @rate_count
        @rating = new_rating
        @rate_count = 1
      else
        sum = @rating * @rate_count
        @rate_count += 1
        @rating = (sum + new_rating) / @rate_count
      end
      self.update(:only => [:rating, :rate_count]) if save_object
    end
  end
  
  def rated?
    return !@rate_count.nil?
  end
end

end
