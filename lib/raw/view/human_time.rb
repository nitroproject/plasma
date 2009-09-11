module Raw::Mixin

module HumanTimeHelper

private

  # Display the time in a 'human' form. Needs the human_time.js
  # javascript file. This method is designed to support 
  # output caching.

  def human_time(time)
    time = time.utc.strftime("%a, %d %b %Y %H:%M:%S GMT")
    %|<span class="human_time" title="#{time}">#{time}</span>|    
  end
  
end

end
