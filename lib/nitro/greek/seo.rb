require "nitro/greek/greeklish"

require "part/content/model/seo"

module SEO
protected
  
  # Make the given string SEO friendly.
  
  def seo_encode(str)
    return nil unless str
    str.greeklish.gsub(/\s/, "-").gsub(/[^\w-]/, "")[0..64]
  end

end
