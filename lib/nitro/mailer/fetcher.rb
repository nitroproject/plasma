require "tmail"
require "facets/string/blank"

require "nitro/mailer/mail"

# The base fetcher class.

class MailFetcher

  attr_accessor :mails

  # Initialize the mail fetcher.
  #
  # Options:
  # * server
  # * port
  # * username
  # * password
  
  def initialize(options={})
    klass = options.delete(:type)
    
    if klass
      module_eval "#{klass.to_s.capitalize}.new(#{options})"
    else
      assign_options(options)
    end
  end

  def fetch
    establish_connection
    @mails = []
    get_messages
    close_connection
    return @mails
  end
  alias_method :fetch!, :fetch

protected
  
  def assign_options(options={})
    %w(server port username password).each do |opt|
      instance_eval("@#{opt} = options[:#{opt}]")
    end
  end

  def establish_connection
    raise NotImplementedError, "This method should be overridden by subclass"
  end
  
  def get_messages
    raise NotImplementedError, "This method should be overridden by subclass"
  end
  
  def close_connection
    raise NotImplementedError, "This method should be overridden by subclass"
  end

  def receive(encoded)
#   mail = Nitro::Mail.new_from_encoded(encoded)
    mail = TMail::Mail.parse(encoded)
    @mails << mail
  end

end

