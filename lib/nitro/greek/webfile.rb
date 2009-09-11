
require 'glue/webfile'
require 'glue/greek/greeklish'

module Glue


#--
# Customize webfile to handle greek filenames.
#++

class WebFile

  # Sanitize a filename. You can override this method to make 
  # this suit your needs.
  
  def self.sanitize(filename)
    ext = File::extname(filename)
    base = File::basename(filename, ext).gsub(/[\\\/\? !@$\(\)]/, '-')[0..64]
    return "#{base.to_greeklish}.#{ext}"
  end

end

end
