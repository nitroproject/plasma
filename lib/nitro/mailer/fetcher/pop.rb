require "secure_pop"

require "nitro/mailer/fetcher"

class PopMailFetcher < MailFetcher

protected
  
  def assign_options(options={})
    if @ssl = options.delete(:ssl)
      @port ||= 995
    end
    super
  end
  
  def establish_connection
    @connection = Net::POP3.new(@server, @port)
    @connection.enable_ssl(OpenSSL::SSL::VERIFY_NONE) if @ssl
    @connection.start(@username, @password)
  end
  
  def get_messages
    unless @connection.mails.empty?
      @connection.each_mail do |msg|
        # Process the message
        begin
          receive(msg.pop)
        rescue => ex
          p ex
          # Store the message for inspection if the receiver errors
          handle_bogus_message(msg.pop)
        end
        # Delete message from server
        msg.delete
      end
    end
  end
  
  def handle_bogus_message(message)
  end
  
  def close_connection
    @connection.finish
  end
  
end

