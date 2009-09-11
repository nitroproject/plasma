
class String

# Convert iso_8859_7 strings to utf8.

def self.iso_8859_7_to_utf8(str)
  array_iso = str.unpack('C*')
  array_enc = []
  array_iso.each do |num|
    case num
      when 0xA1: array_enc <<  0x2018  #  LEFT SINGLE QUOTATION MARK
      when 0xA2: array_enc <<  0x2019  #  RIGHT SINGLE QUOTATION MARK
      when 0xA3: array_enc <<  0x00A3  #  POUND SIGN
      when 0xA4: array_enc <<  0x20AC  #  EURO SIGN
      when 0xA5: array_enc <<  0x20AF  #  DRACHMA SIGN
      when 0xA6: array_enc <<  0x00A6  #  BROKEN BAR
      when 0xA7: array_enc <<  0x00A7  #  SECTION SIGN
      when 0xA8: array_enc <<  0x00A8  #  DIAERESIS
      when 0xA9: array_enc <<  0x00A9  #  COPYRIGHT SIGN
      when 0xAA: array_enc <<  0x037A  #  GREEK YPOGEGRAMMENI
      when 0xAB: array_enc <<  0x00AB  #  LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
      when 0xAC: array_enc <<  0x00AC  #  NOT SIGN
      when 0xAD: array_enc <<  0x00AD  #  SOFT HYPHEN
      when 0xAF: array_enc <<  0x2015  #  HORIZONTAL BAR
      when 0xB0: array_enc <<  0x00B0  #  DEGREE SIGN
      when 0xB1: array_enc <<  0x00B1  #  PLUS-MINUS SIGN
      when 0xB2: array_enc <<  0x00B2  #  SUPERSCRIPT TWO
      when 0xB3: array_enc <<  0x00B3  #  SUPERSCRIPT THREE
      when 0xB4: array_enc <<  0x0384  #  GREEK TONOS
      when 0xB5: array_enc <<  0x0385  #  GREEK DIALYTIKA TONOS
      when 0xB6: array_enc <<  0x0386  #  GREEK CAPITAL LETTER ALPHA WITH TONOS
      when 0xB7: array_enc <<  0x00B7  #  MIDDLE DOT
      when 0xB8: array_enc <<  0x0388  #  GREEK CAPITAL LETTER EPSILON WITH TONOS
      when 0xB9: array_enc <<  0x0389  #  GREEK CAPITAL LETTER ETA WITH TONOS
      when 0xBA: array_enc <<  0x038A  #  GREEK CAPITAL LETTER IOTA WITH TONOS
      when 0xBB: array_enc <<  0x00BB  #  RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
      when 0xBC: array_enc <<  0x038C  #  GREEK CAPITAL LETTER OMICRON WITH TONOS
      when 0xBD: array_enc <<  0x00BD  #  VULGAR FRACTION ONE HALF
      when 0xBE: array_enc <<  0x038E  #  GREEK CAPITAL LETTER UPSILON WITH TONOS
      when 0xBF: array_enc <<  0x038F  #  GREEK CAPITAL LETTER OMEGA WITH TONOS
      when 0xC0: array_enc <<  0x0390  #  GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS
      when 0xC1: array_enc <<  0x0391  #  GREEK CAPITAL LETTER ALPHA
      when 0xC2: array_enc <<  0x0392  #  GREEK CAPITAL LETTER BETA
      when 0xC3: array_enc <<  0x0393  #  GREEK CAPITAL LETTER GAMMA
      when 0xC4: array_enc <<  0x0394  #  GREEK CAPITAL LETTER DELTA
      when 0xC5: array_enc <<  0x0395  #  GREEK CAPITAL LETTER EPSILON
      when 0xC6: array_enc <<  0x0396  #  GREEK CAPITAL LETTER ZETA
      when 0xC7: array_enc <<  0x0397  #  GREEK CAPITAL LETTER ETA
      when 0xC8: array_enc <<  0x0398  #  GREEK CAPITAL LETTER THETA
      when 0xC9: array_enc <<  0x0399  #  GREEK CAPITAL LETTER IOTA
      when 0xCA: array_enc <<  0x039A  #  GREEK CAPITAL LETTER KAPPA
      when 0xCB: array_enc <<  0x039B  #  GREEK CAPITAL LETTER LAMDA
      when 0xCC: array_enc <<  0x039C  #  GREEK CAPITAL LETTER MU
      when 0xCD: array_enc <<  0x039D  #  GREEK CAPITAL LETTER NU
      when 0xCE: array_enc <<  0x039E  #  GREEK CAPITAL LETTER XI
      when 0xCF: array_enc <<  0x039F  #  GREEK CAPITAL LETTER OMICRON
      when 0xD0: array_enc <<  0x03A0  #  GREEK CAPITAL LETTER PI
      when 0xD1: array_enc <<  0x03A1  #  GREEK CAPITAL LETTER RHO
      when 0xD3: array_enc <<  0x03A3  #  GREEK CAPITAL LETTER SIGMA
      when 0xD4: array_enc <<  0x03A4  #  GREEK CAPITAL LETTER TAU
      when 0xD5: array_enc <<  0x03A5  #  GREEK CAPITAL LETTER UPSILON
      when 0xD6: array_enc <<  0x03A6  #  GREEK CAPITAL LETTER PHI
      when 0xD7: array_enc <<  0x03A7  #  GREEK CAPITAL LETTER CHI
      when 0xD8: array_enc <<  0x03A8  #  GREEK CAPITAL LETTER PSI
      when 0xD9: array_enc <<  0x03A9  #  GREEK CAPITAL LETTER OMEGA
      when 0xDA: array_enc <<  0x03AA  #  GREEK CAPITAL LETTER IOTA WITH DIALYTIKA
      when 0xDB: array_enc <<  0x03AB  #  GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA
      when 0xDC: array_enc <<  0x03AC  #  GREEK SMALL LETTER ALPHA WITH TONOS
      when 0xDD: array_enc <<  0x03AD  #  GREEK SMALL LETTER EPSILON WITH TONOS
      when 0xDE: array_enc <<  0x03AE  #  GREEK SMALL LETTER ETA WITH TONOS
      when 0xDF: array_enc <<  0x03AF  #  GREEK SMALL LETTER IOTA WITH TONOS
      when 0xE0: array_enc <<  0x03B0  #  GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS
      when 0xE1: array_enc <<  0x03B1  #  GREEK SMALL LETTER ALPHA
      when 0xE2: array_enc <<  0x03B2  #  GREEK SMALL LETTER BETA
      when 0xE3: array_enc <<  0x03B3  #  GREEK SMALL LETTER GAMMA
      when 0xE4: array_enc <<  0x03B4  #  GREEK SMALL LETTER DELTA
      when 0xE5: array_enc <<  0x03B5  #  GREEK SMALL LETTER EPSILON
      when 0xE6: array_enc <<  0x03B6  #  GREEK SMALL LETTER ZETA
      when 0xE7: array_enc <<  0x03B7  #  GREEK SMALL LETTER ETA
      when 0xE8: array_enc <<  0x03B8  #  GREEK SMALL LETTER THETA
      when 0xE9: array_enc <<  0x03B9  #  GREEK SMALL LETTER IOTA
      when 0xEA: array_enc <<  0x03BA  #  GREEK SMALL LETTER KAPPA
      when 0xEB: array_enc <<  0x03BB  #  GREEK SMALL LETTER LAMDA
      when 0xEC: array_enc <<  0x03BC  #  GREEK SMALL LETTER MU
      when 0xED: array_enc <<  0x03BD  #  GREEK SMALL LETTER NU
      when 0xEE: array_enc <<  0x03BE  #  GREEK SMALL LETTER XI
      when 0xEF: array_enc <<  0x03BF  #  GREEK SMALL LETTER OMICRON
      when 0xF0: array_enc <<  0x03C0  #  GREEK SMALL LETTER PI
      when 0xF1: array_enc <<  0x03C1  #  GREEK SMALL LETTER RHO
      when 0xF2: array_enc <<  0x03C2  #  GREEK SMALL LETTER FINAL SIGMA
      when 0xF3: array_enc <<  0x03C3  #  GREEK SMALL LETTER SIGMA
      when 0xF4: array_enc <<  0x03C4  #  GREEK SMALL LETTER TAU
      when 0xF5: array_enc <<  0x03C5  #  GREEK SMALL LETTER UPSILON
      when 0xF6: array_enc <<  0x03C6  #  GREEK SMALL LETTER PHI
      when 0xF7: array_enc <<  0x03C7  #  GREEK SMALL LETTER CHI
      when 0xF8: array_enc <<  0x03C8  #  GREEK SMALL LETTER PSI
      when 0xF9: array_enc <<  0x03C9  #  GREEK SMALL LETTER OMEGA
      when 0xFA: array_enc <<  0x03CA  #  GREEK SMALL LETTER IOTA WITH DIALYTIKA
      when 0xFB: array_enc <<  0x03CB  #  GREEK SMALL LETTER UPSILON WITH DIALYTIKA
      when 0xFC: array_enc <<  0x03CC  #  GREEK SMALL LETTER OMICRON WITH TONOS
      when 0xFD: array_enc <<  0x03CD  #  GREEK SMALL LETTER UPSILON WITH TONOS
      when 0xFE: array_enc <<  0x03CE  #  GREEK SMALL LETTER OMEGA WITH TONOS
    else
      array_enc << num
    end
  end
  array_enc.pack('U*')
end

def iso_8859_7_to_utf8
  String.iso_8859_7_to_utf8(self)
end

def self.utf8_to_iso_8859_7(str)
  return nil unless str
  return str.unpack('U*').collect do |c|
    c > 127 ? c - 0x02d0 : c
  end.pack('C*')
end

def utf8_to_iso_8859_7
  String.utf8_to_iso_8859_7(self)
end

end
