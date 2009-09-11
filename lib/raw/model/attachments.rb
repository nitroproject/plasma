require "facets/inflect"
require "facets/kernel/eigenclass"
require "facets/string/blank"

require "raw/controller/uploads"

# Add support for attachments to the base class. The attachements
# are saved to:
#
# upload_dir/class_plural/pk/filename.ext
    
module Attachments
  
  attr_accessor :attachment, String
  alias_method :attachment_href, :attachment
  
  def has_attachment?
    !@attachment.blank?
  end

  def attachment_filename
    File.basename(@attachment)
  end
  
  def self.included(base) 
    now = Time.now
    plural = base.name.demodulize.underscore.plural
    
    base.eigenclass.send(:define_method, :attachment_upload_dir) do |param|
      File.join(Uploads.upload_dir, plural, now.year.to_s, now.month.to_s)
    end
  end

end
