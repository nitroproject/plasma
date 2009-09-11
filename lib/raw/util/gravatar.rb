require "digest/md5"

# How the URL is constructed
#
# A gravatar is a dynamic image resource that is requested from 
# our server. The request URL is presented here, broken into its 
# segments. The URL always begins with
#
# http://www.gravatar.com/avatar.php?
#
# a mandatory parameter named "gravatar_id" follows this. It's 
# value is the hexadecimal MD5 hash of the requested user's 
# email address with all whitespace trimmed. The value is case 
# insensitive.
#
# gravatar_id=279aa12c3326f87c460aa4f31d18a065
#
# An optional "rating" parameter may follow with a value of 
# [ G | PG | R | X ] that determines the highest rating 
# (inclusive) that will be returned.
#
# &rating=R
#
# An optional "size" parameter may follow that specifies the 
# desired width and height of the gravatar. Valid values are 
# from 1 to 80 inclusive. Any size other than 80 will cause the 
# original gravatar image to be downsampled using bicubic 
# resampling before output.
#
# &size=40
# 
# An optional "default" parameter may follow that specifies the 
# full, URL encoded URL, protocol included, of a GIF, JPEG, or 
# PNG image that should be returned if either the requested 
# email address has no associated gravatar, or that gravatar 
# has a rating higher than is allowed by the "rating" parameter.
#
# &default=http%3A%2F%2Fwww.example.com%2Fsomeimage.jpg

module Gravatar

  # FIXME: make this a setting.
  
  DEFAULT_OPTIONS = {:size => 80}

  def gravatar_uri(email, options = {})
    return "" unless email # FIXME: return default picture!
    
    options = DEFAULT_OPTIONS.merge(options)
  
    id = Digest::MD5.hexdigest(email)
    uri = "http://gravatar.com/avatar.php?gravatar_id=#{id}"

    for k, v in options
      uri += "&#{k}=#{v}" unless v.nil?
    end

    return uri    
  end
  
  def gravatar_img(email, options = {})
    %{<img src="#{gravatar_uri(email, options)}" style="width: 80px; height: 80px" />}
  end

end

