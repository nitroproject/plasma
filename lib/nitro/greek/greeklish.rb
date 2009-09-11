require "nitro/encoding/iso_8859_7"

GREEKLISH_CHAR_MAP = {
  "\341" => 'a',
  "\301" => 'A',
  "\334" => 'a',
  "\301" => 'A',
  "\342" => 'b',
  "\302" => 'B',
  "\343" => 'g',
  "\303" => 'G',
  "\344" => 'd',
  "\304" => 'D',
  "\345" => 'e',
  "\305" => 'E',
  "\335" => 'e',
  "\305" => 'E',
  "\346" => 'z',
  "\306" => 'Z',
  "\347" => 'h',
  "\307" => 'H',
  "\336" => 'h',
  "\307" => 'H',
  "\350" => '8',
  "\310" => '8',
  "\351" => 'i',
  "\311" => 'I',
  "\337" => 'i',
  "\311" => 'I',
  "\352" => 'k',
  "\312" => 'K',
  "\353" => 'l',
  "\313" => 'L',
  "\354" => 'm',
  "\314" => 'M',
  "\355" => 'n',
  "\315" => 'N',
  "\356" => 'ks',
  "\316" => 'Ks',
  "\357" => 'o',
  "\317" => 'O',
  "\374" => 'o',
  "\274" => 'O',
  "\360" => 'p',
  "\320" => 'P',
  "\361" => 'r',
  "\321" => 'R',
  "\363" => 's',
  "\362" => 's',
  "\323" => 'S',
  "\364" => 't',
  "\324" => 'T',
  "\365" => 'y',
  "\325" => 'Y',
  "\375" => 'y',
  "\325" => 'Y',
  "\366" => 'f',
  "\326" => 'F',
  "\367" => 'x',
  "\327" => 'X',
  "\370" => 'ps',
  "\330" => 'Ps',
  "\371" => 'w',
  "\331" => 'W',
  "\376" => 'w',
  "\277" => 'W'
}

class String

  class << self

	# Convert a string to greeklish.

	def to_greeklish(str)
		return nil unless str
		str.utf8_to_iso_8859_7.gsub(/./m) do |m|
			c = GREEKLISH_CHAR_MAP[m]
			c.nil? ? m : c
	  end
	end
  alias_method :greeklish, :to_greeklish
  
  end

  # Convert self to greeklish
  
  def to_greeklish
    String.to_greeklish(self)
  end
  alias_method :greeklish, :to_greeklish

end

if $0 == __FILE__

  # Build the map.
  
  gc = %w{ α Α ά Α β Β γ Γ δ Δ ε Ε έ Ε ζ Ζ η Η ή Η θ Θ ι Ι ί Ι κ Κ λ Λ μ Μ ν Ν ξ Ξ ο Ο ό Ό π Π ρ Ρ σ ς Σ τ Τ υ Υ ύ Υ φ Φ χ Χ ψ Ψ ω Ω ώ Ώ }
  ec = %w{ a A a A b B g G d D e E e E z Z h H h H 8 8 i I i I k K l L m M n N ks Ks o O o O p P r R s s S t T y Y y Y f F x X ps Ps w W w W }
   
  gc.size.times do |i|
    g = gc[i].utf8_to_iso_8859_7
    puts %|#{g.inspect} => '#{ec[i]}',| 
  end
  
end
