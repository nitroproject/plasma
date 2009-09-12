# This helper should be included to all Admin plugins. Provides
# security and other utilities.

module AdminHelper
  def self.included(base)
    super
    base.before(:call => :authorize)
  end
  
  #--
  # Generally you do not override this method.
  #++
  
  def authorize
    raise "Access denied" unless authorized_user? 
  end
  
  # Is the user authorizes to browse Admin pages?
  #
  #--
  # Override this method in your application
  #++
  
  def authorized_user?
    return true
  end
end
