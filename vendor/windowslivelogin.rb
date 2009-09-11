#######################################################################
# FILE:        windowslivelogin.rb                                     
#                                                                      
# DESCRIPTION: Sample implementation of Web Authentication protocol in 
#              Ruby. Also includes trusted login and application 
#              verification sample implementations.
#
# VERSION:     1.0
#
# Copyright (c) 2007 Microsoft Corporation.  All Rights Reserved.
#######################################################################

require 'cgi'
require 'uri'
require 'base64'
require 'openssl'
require 'net/https'
require 'rexml/document'

#######################################################################
# Implementation of the basic methods needed for Web Authentication.
#######################################################################
class WindowsLiveLogin
  #####################################################################
  # Stub implementation for logging errors. If you want to enable
  # debugging output using the default mechanism, specify an output
  # file here or nil to disable.
  #####################################################################
  def setDebug(file) 
    @debug = file 
  end

  #####################################################################
  # Stub implementation for logging errors. By default, this function
  # does nothing if the debug flag has not been set with setDebug.
  # Otherwise, it tries to write the SDK error message to the file
  # that is specified.
  #####################################################################
  def debug(error)
    return if @debug.nil? or @debug.empty?
    begin
      File.open(@debug, "a"){|f| f.puts(error)}
    rescue
      warn("Error: debug: Failed to open #{@debug} for logging.")
    end
    nil 
  end

  #####################################################################
  # Stub implementation for handling a fatal error.
  #####################################################################
  def fatal(error)
    debug(error)
    raise(error)
  end

  #####################################################################
  # Holds the user information after a successful login.
  #
  # 'timestamp' is the time as obtained from the SSO token.
  # 'id' is the pairwise unique ID for the user.
  # 'context' is the application context that was originally passed to
  # the login request, if any.
  # 'token' is the encrypted Web Authentication token that contains the 
  # UID. This can be cached in a cookie and the UID can be retrieved by 
  # calling the processToken method.
  # 'usePersistentCookie?' indicates whether the application is
  # expected to store the user token in a session or persistent
  # cookie.
  #####################################################################
  class User
    attr_reader :timestamp, :id, :context, :token

    def usePersistentCookie?
      @usePersistentCookie
    end

    def initialize(timestamp, id, flags, context, token)
      self.timestamp = timestamp
      self.id = id
      self.flags = flags
      self.context = context
      self.token = token
    end

    private
    attr_writer :timestamp, :id, :flags, :context, :token

    def timestamp=(timestamp)
      raise("Error: User: Null timestamp in token.") unless timestamp
      timestamp = timestamp.to_i
      raise("Error: User: Invalid timestamp: #{timestamp}") if (timestamp <= 0)
      @timestamp = Time.at timestamp
    end

    def id=(id)
      raise("Error: User: Null id in token.") unless id
      raise("Error: User: Invalid id: #{id}") unless (id =~ /^\w+$/)
      @id = id
    end

    def flags=(flags)
      @usePersistentCookie = false
      if flags
        @usePersistentCookie = ((flags.to_i % 2) == 1)
      end
    end
  end

  #####################################################################
  # Initialize the WindowsLiveLogin module with the application ID,
  # secret key, and security algorithm.  
  #
  # We recommend that you employ strong measures to protect the
  # secret key. The secret key should never be exposed to the Web
  # or other users.
  #
  # Be aware that if you do not supply these settings at
  # initialization time, you may need to set the corresponding
  # properties manually.
  #####################################################################
  def initialize(appid=nil, secret=nil, securityalgorithm=nil)
    self.appid = appid if appid
    self.secret = secret if secret
    self.securityalgorithm = securityalgorithm if securityalgorithm
  end
  
  #####################################################################
  # Initialize the WindowsLiveLogin module from a settings file. 
  #
  # 'settingsFile' specifies the location of the XML settings file
  # that contains the application ID, secret key and security
  # algorithm. The file is of the following format:
  #
  # <windowslivelogin>
  #   <appid>APPID</appid>
  #   <secret>SECRET</secret>
  #   <securityalgorithm>wsignin1.0</securityalgorithm>
  # </windowslivelogin>
  #
  # We recommend that you store the Windows Live Login settings file
  # in an area on your server that cannot be accessed through the 
  # Internet. This file contains important confidential information.
  #####################################################################
  def self.initFromXml(settingsFile)
    o = self.new
    settings = o.parseSettings(settingsFile)
    o.appid = settings['appid']
    o.secret = settings['secret']
    o.securityalgorithm = settings['securityalgorithm']
    o.baseurl = settings['baseurl']
    o.secureurl = settings['secureurl']
    o.setDebug(settings['debug'])
    o
  end

  #####################################################################
  # Use this property to set your application ID if you did not provide
  # one at initialization time.
  #####################################################################
  def appid=(appid)
    if (appid.nil? or appid.empty?)
      fatal("Error: appid: Null application ID.") 
    end
    if (not appid =~ /^\w+$/)
      fatal("Error: appid: Application ID must be alpha-numeric: " + appid)
    end
    @appid = appid
  end

  #####################################################################
  # Returns the application ID.  
  #####################################################################
  def appid
    if (@appid.nil? or @appid.empty?)
      fatal("Error: appid: App ID was not set. Aborting.")
    end
    @appid
  end

  #####################################################################
  # Use this property to set your secret key if you did not
  # provide one at initialization time.
  #####################################################################
  def secret=(secret)
    if (secret.nil? or secret.empty? or (secret.size < 16))
      fatal("Error: secret=: Secret must be non-null and at least 16 characters.") 
    end
    @signkey = derive(secret, "SIGNATURE")
    @cryptkey = derive(secret, "ENCRYPTION")
  end

  #####################################################################
  # Set or get the version of the security algorithm being used.
  #####################################################################
  attr_accessor :securityalgorithm

  def securityalgorithm
    if(@securityalgorithm.nil? or @securityalgorithm.empty?)
      "wsignin1.0"
    else
      @securityalgorithm
    end
  end

  #####################################################################
  # Set or get the base URL to use for the Windows Live Login server.
  # You should not have to use or change this. Furthermore, we
  # recommend that you use the Sign In control instead of the URL
  # methods provided here.
  #####################################################################
  attr_accessor :baseurl

  def baseurl
    if(@baseurl.nil? or @baseurl.empty?)
      "http://login.live.com/"
    else
      @baseurl
    end
  end

  #####################################################################
  # Set or get the secure (HTTPS) URL to use for the Windows Live Login
  # server. You should not have to use or change this directly.
  #####################################################################
  attr_accessor :secureurl

  def secureurl
    if(@secureurl.nil? or @secureurl.empty?)
      "https://login.live.com/"
    else
      @secureurl
    end
  end

  #####################################################################
  # Processes the login response from Windows Live Login.
  #
  # 'query' contains the preprocessed POST table such as that
  # returned by CGI.params or by Rails (the unprocessed POST string
  # might also be used here but we do not recommend it).
  #
  # The method returns a User object on successful login; otherwise 
  # nil.
  #####################################################################
  def processLogin(query)
    query = parse query
    unless query
      debug("Error: processLogin: Failed to parse query.")
      return
    end
    action = query['action']
    unless action == 'login'
      debug("Warning: processLogin: query action ignored: #{action}.")
      return
    end
    token = query['stoken']
    context = CGI.unescape(query['appctx']) if query['appctx']
    processToken(token, context)
  end

  #####################################################################
  # Returns the sign in URL to use for Windows Live Login. We
  # recommend that you use the Sign In control instead.
  # 
  # If you specify it, 'context' will be returned as-is in the login
  # response for site-specific use.
  #####################################################################
  def getLoginUrl(context=nil)
    url = baseurl + "wlogin.srf?appid=#{appid}"
    url += "&alg=#{securityalgorithm}"
    url += "&appctx=#{CGI.escape(context)}" if context
    url
  end

  #####################################################################
  # Returns the sign-out URL to use for Windows Live Login. We
  # recommend that you use the Sign In control instead.
  #####################################################################
  def getLogoutUrl
    baseurl + "logout.srf?appid=#{appid}"
  end

  #####################################################################
  # Decodes and validates a Web Authentication token. Returns a User 
  # object on success. If a context is passed in, it will be returned 
  # as the context field in the User object.
  #####################################################################
  def processToken(token, context=nil)
    if token.nil? or token.empty?
      debug("Error: processToken: Null/empty token.")
      return
    end
    stoken = decodeToken token
    stoken = validateToken stoken
    stoken = parse stoken
    unless stoken
      debug("Error: processToken: Failed to decode/validate token: #{token}")
      return
    end
    sappid = stoken['appid']
    unless sappid == appid
      debug("Error: processToken: Application ID in token did not match ours: #{sappid}, #{appid}")
      return
    end
    begin
      user = User.new(stoken['ts'], stoken['uid'], stoken['flags'], 
                      context, token)
      return user
    rescue Exception => e
      debug("Error: processToken: Contents of token considered invalid: #{e}")
      return
    end
  end

  #####################################################################
  # When a user signs out of Windows Live or a Windows Live
  # application, a best-effort attempt is made at signing out the user
  # from all other Windows Live applications the user might be logged
  # in to. This is done by calling the handler page for each
  # application with 'action' set to 'clearcookie' in the query
  # string. The application handler is then responsible for clearing
  # any cookies or data associated with the login. After successfully
  # logging out the user, the handler should return a GIF (any GIF) as
  # response to the action=clearcookie query.
  #
  # This function returns an appropriate content type and body response
  # that the application handler can return to signify a successful
  # sign-out from the application.
  #####################################################################
  def getClearCookieResponse()
    type = "image/gif"
    content = "R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAEALAAAAAABAAEAAAIBTAA7"
    content = Base64.decode64(content)
    return type, content
  end

  #####################################################################
  # Decode the given token. Returns nil on failure.
  #
  # First, the string is URL unescaped and base64 decoded.
  # Second, the IV is extracted from the first 16 bytes of the string.
  # Finally, the string is decrypted by using the encryption key.
  #####################################################################
  def decodeToken(token)
    if (@cryptkey.nil? or @cryptkey.empty?)
      fatal("Error: decodeToken: Secret key was not set. Aborting.")
    end
    token =  u64(token)
    if (token.nil? or (token.size <= 16) or !(token.size % 16).zero?)
      debug("Error: decodeToken: Attempted to decode invalid token.")
      return
    end
    iv = token[0..15]
    crypted = token[16..-1]
    begin
      aes128cbc = OpenSSL::Cipher::AES128.new("CBC")
      aes128cbc.decrypt
      aes128cbc.iv = iv
      aes128cbc.key = @cryptkey
      decrypted = aes128cbc.update(crypted) + aes128cbc.final
    rescue Exception => e
      debug("Error: decodeToken: Decryption failed: #{token}, #{e}")
      return
    end
    decrypted
  end

  #####################################################################
  # Creates a signature for the given string by using the signature 
  # key.
  #####################################################################
  def signToken(token)
    if (@signkey.nil? or @signkey.empty?)
      fatal("Error: signToken: Secret key was not set. Aborting.")
    end
    begin
      digest = OpenSSL::Digest::SHA256.new
      return OpenSSL::HMAC.digest(digest, @signkey, token)
    rescue Exception => e
      debug("Error: signToken: Signing failed: #{token}, #{e}")
      return
    end
  end

  #####################################################################
  # Extracts the signature from the token and validates it.
  #####################################################################
  def validateToken(token)
    if (token.nil? or token.empty?)
      debug("Error: validateToken: nil/empty token.")
      return
    end
    body, sig = token.split("&sig=")
    if (body.nil? or sig.nil?)
      debug("Error: validateToken: Invalid token: #{token}")
      return
    end
    sig = u64(sig)
    return token if (sig == signToken(body))
    debug("Error: validateToken: Signature did not match.")
    return
  end
end

#######################################################################
# Implementation of the methods needed to perform Windows Live 
# application verification as well as trusted login.
#######################################################################
class WindowsLiveLogin
  #####################################################################
  # Generates an Application Verifier token.
  #
  # An IP address can optionally be included in the token.
  #####################################################################
  def getAppVerifier(ip=nil)
    token = "appid=#{appid}&ts=#{timestamp}"
    token += "&ip=#{ip}" if ip
    token += "&sig=#{e64(signToken(token))}"
    CGI.escape token
  end

  #####################################################################
  # Returns the URL needed to retrieve the application security token.
  #
  # By default, the application security token will be generated for
  # the Windows Live site; a specific Site ID can optionally be
  # specified in 'siteid'. The IP address can also optionally be
  # included in 'ip'.
  #
  # If 'js' is nil, then a JavaScript Output Notation (JSON) response 
  # is returned: 
  #
  # {"token":"<value>"}
  #
  # Otherwise, a JavaScript response is returned. It is assumed that
  # WLIDResultCallback is a custom function implemented to handle the
  # token value:
  #
  # WLIDResultCallback("<tokenvalue>");
  #####################################################################
  def getAppLoginUrl(siteid=nil, ip=nil, js=nil)
    url = secureurl + "wapplogin.srf?app=#{getAppVerifier(ip)}"
    url += "&alg=#{securityalgorithm}"
    url += "&id=#{siteid}" if siteid
    url += "&js=1" if js
    url
  end

  #####################################################################
  # Retrieves the application security token for application
  # verification from the application login URL.  
  #
  # By default, the application security token will be generated for
  # the Windows Live site; a specific Site ID can optionally be
  # specified in 'siteid'. The IP address can also optionally be
  # included in 'ip'.
  #
  # Implementation note: The application security token is downloaded
  # from the application login URL in JSON format {"token":"<value>"},
  # so we need to extract <value> from the string and return it as
  # seen here.
  #####################################################################
  def getAppSecurityToken(siteid=nil, ip=nil)
    url = getAppLoginUrl(siteid, ip)
    begin
      ret = fetch url
      ret.value # raises exception if fetch failed
      body = ret.body
      body.scan(/\{"token":"(.*)"\}/){|match|
        return match
      }
      debug("Error: getAppSecurityToken: Failed to extract token: #{body}")
    rescue Exception => e
      debug("Error: getAppSecurityToken: Failed to get token: #{e}")
    end    
    return
  end

  #####################################################################
  # Returns a string that can be passed to the getTrustedParams
  # function as the 'retcode' parameter. If this is specified as the
  # 'retcode', the application will be used as return URL after it
  # finishes trusted login.
  #####################################################################
  def getAppRetCode
    "appid=#{appid}"
  end

  #####################################################################
  # Returns a table of key-value pairs that must be posted to the
  # login URL for trusted login. Use HTTP POST to do this. Be aware
  # that the values in the table are neither URL nor HTML escaped and
  # may have to be escaped if you are inserting them in code such as
  # an HTML form.
  #
  # User to be trusted on the local site is passed in as string 'user'.
  #
  # Optionally, 'retcode' specifies the resource to which successful
  # login is redirected, such as Windows Live Mail, and is typically a
  # string in the format 'id=2000'. If you pass in the value from
  # getAppRetCode instead, login will be redirected to the application.
  # Otherwise, an HTTP 200 response is returned.
  #####################################################################
  def getTrustedParams(user, retcode=nil)
    token = getTrustedToken(user)
    return unless token
    token = %{<wst:RequestSecurityTokenResponse xmlns:wst="http://schemas.xmlsoap.org/ws/2005/02/trust"><wst:RequestedSecurityToken><wsse:BinarySecurityToken xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">#{token}</wsse:BinarySecurityToken></wst:RequestedSecurityToken><wsp:AppliesTo xmlns:wsp="http://schemas.xmlsoap.org/ws/2004/09/policy"><wsa:EndpointReference xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing"><wsa:Address>uri:WindowsLiveID</wsa:Address></wsa:EndpointReference></wsp:AppliesTo></wst:RequestSecurityTokenResponse>}
    params = {}
    params['wa'] = securityalgorithm
    params['wresult'] = token
    params['wctx'] = retcode if retcode
    params
  end

  #####################################################################
  # Returns the trusted login token in the format that is needed by a
  # control doing trusted login.
  #
  # User to be trusted on the local site is passed in as string
  # 'user'.
  #####################################################################
  def getTrustedToken(user)
    if user.nil? or user.empty?
      debug('Error: getTrustedToken: Null user specified.')
      return
    end
    token = "appid=#{appid}&uid=#{CGI.escape(user)}&ts=#{timestamp}"
    token += "&sig=#{e64(signToken(token))}"
    CGI.escape token
  end

  #####################################################################
  # Returns the trusted sign-in URL to use for Windows Live Login. 
  #####################################################################
  def getTrustedLoginUrl
    secureurl + "wlogin.srf"
  end

  #####################################################################
  # Returns the trusted sign-out URL to use for Windows Live Login.
  #####################################################################
  def getTrustedLogoutUrl
    secureurl + "logout.srf?appid=#{appid}"
  end
end

#######################################################################
# Helper methods.
#######################################################################
class WindowsLiveLogin
  def parseSettings(settingsFile)
    settings = {}
    begin
      file = File.new(settingsFile)
      doc = REXML::Document.new file

      appid = doc.root.elements['appid']
      fatal("Invalid application ID") if (appid.nil? or appid.text.empty?)
      settings['appid'] = appid.text

      secret = doc.root.elements['secret']
      fatal("Invalid secret") if (secret.nil? or secret.text.empty?)
      settings['secret'] = secret.text

      securityalgorithm = doc.root.elements['securityalgorithm']
      settings['securityalgorithm'] = securityalgorithm.text unless securityalgorithm.nil?

      baseurl = doc.root.elements['baseurl']
      settings['baseurl'] = baseurl.text unless baseurl.nil?

      secureurl = doc.root.elements['secureurl']
      settings['secureurl'] = secureurl.text unless secureurl.nil?

      debug = doc.root.elements['debug']
      settings['debug'] = debug.text unless debug.nil?
    rescue Exception => e
      fatal("Error: parseSettings: Error while reading #{settingsFile}: #{e}")
    end
    return settings
  end

  private

  #####################################################################
  # Derive the key, given the secret key and prefix as described in the
  # SDK documentation.
  #####################################################################
  def derive(secret, prefix)
    begin
      fatal("Nil/empty secret.") if (secret.nil? or secret.empty?)
      key = prefix + secret
      key = OpenSSL::Digest::SHA256.digest(key)
      return key[0..15]
    rescue Exception => e
      debug("Error: derive: #{e}")
      return
    end
  end

  #####################################################################
  # Helper method to parse query string and return a table 
  # {String=>String}
  #
  # If a table is passed in from CGI.params, we convert it from
  # {String=>[]} to {String=>String}. I believe Rails uses symbols
  # instead of strings in general, so we convert from symbols to 
  # strings here also.
  #####################################################################
  def parse(input)
    if (input.nil? or input.empty?)
      debug("Error: parse: Nil/empty input.")
      return
    end

    pairs = {}
    if (input.class == String)
      input = input.split('&')
      input.each{|pair|
        k, v = pair.split('=')
        pairs[k] = v
      }
    else
      input.each{|k, v|
        v = v[0] if (v.class == Array)
        pairs[k.to_s] = v.to_s
      }
    end
    return pairs
  end

  #####################################################################
  # Generates a timestamp suitable for the application verifier token.
  #####################################################################
  def timestamp
    Time.now.to_i.to_s
  end

  #####################################################################
  # Base64-encode and URL-escape a string.
  #####################################################################
  def e64(s)
    return unless s
    CGI.escape Base64.encode64(s)
  end

  #####################################################################
  # URL-unescape and Base64-decode a string.
  #####################################################################
  def u64(s)
    return unless s
    Base64.decode64 CGI.unescape(s)
  end

  #####################################################################
  # Fetch the contents given a URL.
  #####################################################################
  def fetch(url)
      url = URI.parse url
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == "https")
      http.request_get url.request_uri
  end
end
