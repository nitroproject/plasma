require "RMagick"
require "digest/sha2"

require "facets/file/write"

module Raw::Mixin

# Add CAPTCHA functionality to a controller.
#
# A lot of effort was given to make this implementation output 
# caching friendly.

module CAPTCHA

  FILE = File.expand_path(".temp/captcha.txt")
  
  def self.get(context)
    File.read(FILE)
  rescue 
    return nil
  end  

  def self.set(captcha, context)
    File.write(File.join(context.application.temp_dir, "captcha.txt"), captcha)    
  end

  def self.encode(captcha)
    # TODO: Something faster here, we don't need too much security.
    Digest::SHA256.hexdigest("#{captcha}#{Session.secret}")
  end

  # Generate the html markup to display the captcha. A random
  # String is appended to the image url to avoid browser caching
  # problems.
  #
  # The current captcha is stored in the session. The user input
  # is cheked against the session captcha to avoid 'captcha-stealing' 
  # by other users.
  
  def captcha_img
    unless captcha = CAPTCHA.get(@context)
      generate_captcha
      captcha = CAPTCHA.get(@context)
    end
    session[:CAPTCHA] = CAPTCHA.encode(captcha)
    %|<img src="/captcha.gif?rnd=#{rand(999999999)}" />|
  end

  # Ensure the captcha is valid. Typically used as an aspect.
  
  def ensure_captcha!
    unless captcha_valid?
      flash_error "Invalid captcha"
      redirect_to_referer
    end    
  end
  alias_method :ensure_captcha, :ensure_captcha! # compatibility !
        
private

  # Generate the captcha image.
  #
  # Options:
  #
  #   :code = the captcha code (typically numeric)
  #   :width = the width of the captcha image
  #   :height = the height of the captcha image
  #   :the filename of the captcha image
   
  def generate_captcha(options = {})
    session.delete(:CAPTCHA)
     
    code = options.fetch(:code, (1000 + rand(8999)).to_s)
    width = options.fetch(:width, 128)
    height = options.fetch(:height, 30)
    filename = options.fetch(:filename, "captcha.gif")
    
    CAPTCHA.set(code, @context)

    img = Magick::Image.new(128, 30) {
      self.background_color = "#dddddd"
    }
    drw = Magick::Draw.new

    # draw noise lines.

    drw.stroke("#888888")
    8.times do |i|
      drw.line(rand(width), rand(height), rand(width), rand(height))
    end
    drw.draw(img)

    # draw code.

    drw.gravity = Magick::CenterGravity
    drw.font_weight("bold")
    code.size.times do |i|        
      c = code.slice(i, 1)
      drw.pointsize = ps = 20 + rand(8)
      drw.annotate(img, 63, 30, i * ps, 0, c) {
        self.rotation = (rand(2)==1 ? rand(30) : -rand(30))
      }
    end

    img.write(File.join(@context.application.public_dir, filename))
  end

  # Check if the user entered captcha is valid, ie matches the
  # graphic displayed. If the captcha is used (is valid) then
  # regenerate the image and remove from the global cache. For 
  # simplicity we accepth the Global[:CAPTCHA] to be nil.
  #
  # Check against the session copy to avoid captcha stealing
  # problems.
  #
  # Verified users skip the captcha test.
  
  def captcha_valid?
    return true if User.current.verified?

    if session[:CAPTCHA].nil? or CAPTCHA.encode(request["captcha"]) == session[:CAPTCHA]
      generate_captcha
      return true
    else
      return false
    end
  end

end

end
