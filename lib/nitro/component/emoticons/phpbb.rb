require "nitro/component/emoticons"

# PhpBB2 Emoticons.

class Emoticons

  RULES = {
    /:(\w+):/ => '\1',
    /:(-?)\)/ => "smile",
    /:(-?)\(/ => "sad",
    /;(-?)\)/ => "wink",
    /:(-?)P/ => "razz"
  }
  
end
