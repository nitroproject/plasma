# Suppot for date/time formatting in Greek.

GREEK_MONTHS = %w{
  Ιανουάριος
  Φεβρουάριος
  Μάρτιος
  Απρίλιος
  Μάϊος
  Ιούνιος
  Ιούλιος
  Αύγουστος
  Σεπτέμβριος
  Οκτώβριος
  Νοέμβριος
  Δεκέμβριος
}

# FIXME: find a better name.

GREEK_MONTHS_2 = %w{
  Ιανουαρίου
  Φεβρουαρίου
  Μαρτίου
  Απριλίου
  Μαΐου
  Ιουνίου
  Ιουλίου
  Αυγούστου
  Σεπτεμβρίου
  Οκτωβρίου
  Νοεμβρίου
  Δεκεμβρίου
}

GREEK_MONTHS_SHORT = %w{
  Ιαν
  Φεβ
  Μάρ
  Απρ
  Μάϊ
  Ιού
  Ιού
  Αύγ
  Σεπ
  Οκτ
  Νοέ
  Δεκ
}

class Time
  
  def greek(date_only = false)
    str = "#{day} #{GREEK_MONTHS_2[month-1]} #{year}"
    str << %{ #{strftime "%H:%M"}} unless date_only
    return str
  end
  alias_method :greek_full, :greek

end

