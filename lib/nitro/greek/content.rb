require 'part/content/model/content'
require 'glue/greek/greeklish'

#--
# Customize named content to handle greek filenames.
#++

class NamedContent < Content

  # TODO: better mapping.
  
  def setup_name
    @name = @title.gsub(/ /, '-').gsub(/[!\.\?@\&$;,*#]/, '').to_greeklish[0..64]
  end

end
