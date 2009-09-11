
# Expand/contract emoticons markup.

class Emoticons

  # The directory where emoticon images reside.
  
  setting :image_dir, :default => "/m/emt", :doc => "The root directory where emoticon images reside"

  class << self
  
    def expand(str)
      xstr = str.dup
      expand!(xstr)
      return xstr
    end

    def expand!(str)
      for rule, name in RULES
        img = %{<img src="/m/emt/#{name}.gif" />}
        str.gsub!(rule, img)
      end
    end

    def expand_absolute(str)
      xstr = str.dup
      expand!(xstr)
      return xstr
    end

    def expand_absolute!(str)
      for rule, name in RULES
        img = %{<img src="#{Context.current.host_uri}/m/emt/#{name}.gif" />}
        str.gsub!(rule, img)
      end
    end
      
  end
  
end
