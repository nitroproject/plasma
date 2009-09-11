require "net/imap"

require "plain_imap"

require "nitro/mailer/fetcher"

class ImapMailFetcher < MailFetcher
    
protected
    
    def assign_options(options={})
      @authentication = options.delete(:authentication) || "PLAIN"
      super
    end
    
    def establish_connection
      @connection = Net::IMAP.new(@server)
      @connection.authenticate(@authentication, @username, @password)
    end
    
    def get_messages
      @connection.select("INBOX")
      @connection.search(["ALL"]).each do |message_id|
        msg = @connection.fetch(message_id,"RFC822")[0].attr["RFC822"]
        # process the email message
        begin
          receive(msg)
        rescue
          # Store the message for inspection if the receiver errors
          handle_bogus_message(msg)
        end
        # Mark message as deleted 
        @connection.store(message_id, "+FLAGS", [:Deleted])
      end
    end
    
    def handle_bogus_message(message)
      @connection.append("bogus", message)
    end
    
    def close_connection
      # expunge messages and log out.
      @connection.expunge
      @connection.logout
      @connection.disconnect
    end
    
end
