require 'net/http'
require 'net/https'
require 'uri'
require 'paypal_profile'
#require 'paypal_utils'
module PayPalSDKCallers   
  class Caller    
    include PayPalSDKProfiles
    attr_reader :ssl_strict
    ## to make long names shorter for easier access and to improve readability define the following variables
    @@profile = PayPalSDKProfiles::Profile
    ## Proxy server information hash
    @@pi=@@profile.proxy_info
    ## merchant credentials hash
    @@cre=@@profile.credentials
    ## client information such as version, source hash
    @@ci=@@profile.client_info
    ## endpoints of PayPal hash
    @@ep=@@profile.endpoints     
#    @@PayPalLog=PayPalSDKUtils::Logger.getLogger('PayPal.log')    
    ## CTOR
    def initialize(ssl_verify_mode=false)
      @ssl_strict = ssl_verify_mode  
      @@headers = {'Content-Type' => 'html/text'}  
    end   
    ## call method uses HTTP::Net library to talk to PayPal WebServices.
    def call(requesth)   
      # convert hash values to CGI request (NVP) format
      req_data= "#{hash2cgiString(requesth)}&#{hash2cgiString(@@cre)}&#{hash2cgiString(@@ci)}"  
      if (@@pi["USE_PROXY"])
        if( @@pi["USER"].nil? || @@pi["PASSWORD"].nil? )
          http = Net::HTTP::Proxy(@@pi["ADDRESS"],@@pi["PORT"]).new(@@ep["SERVER"], 443)
        else 
          http = Net::HTTP::Proxy(@@pi["ADDRESS"],@@pi["PORT"],@@pi["USER"], @@pi["PASSWORD"]).new(@@ep["SERVER"], 443)
        end        
      else 
        http = Net::HTTP.new(@@ep["SERVER"], 443)                       
      end       
      http.verify_mode    = OpenSSL::SSL::VERIFY_NONE unless ssl_strict
      http.use_ssl        = true 
      maskeddata=req_data.sub(/PWD=[^&]*\&/,'PWD=XXXXXX&')
#      @@PayPalLog.info "Sent: #{maskeddata}"  
      contents, data = http.post2(@@ep["SERVICE"], req_data, @@headers)    
#      @@PayPalLog.info "Received: #{CGI.unescape(data)}"
      return contents, data
    end    
  end
end  

