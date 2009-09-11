require 'glue/karma'

module Lovable

  def self.included(mod)
    mod.send :include, Karma
  end

  def loved_by(lover)
    unless lover.votes.include?(self) or (user == lover)
      lover.votes << self
      
      @users_count += 1
      @karma += lover.karma

      consider!

      lover.save
      self.save
    end
  end
  
  def hated_by(hater)
    unless hater.hates.include?(self) or (user == hater)
      hater.hates << self
      
      @karma -= hater.karma

      consider!
      
      hater.save
      self.save
    end
  end

end
