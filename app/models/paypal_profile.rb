module PayPalSDKProfiles 
  # Method to convert a hash to a string of name and values delimited by '&' as name1=value1&name2=value2...&namen=valuen
  def hash2cgiString(h)
    h.map { |a| a.join('=') }.join('&') 
  end
  class Profile         
    cattr_accessor :credentials 
    cattr_accessor :endpoints 
    cattr_accessor :client_info 
    cattr_accessor :proxy_info 
    cattr_accessor :PAYPAL_EC_URL 
    cattr_accessor :DEV_CENTRAL_URL 
    @@PAYPAL_EC_URL="https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&useraction=commit&token="
    @@DEV_CENTRAL_URL="https://developer.paypal.com"
###############################################################################################################################    
#    NOTE: Production code should NEVER expose API credentials in any way! They must be managed securely in your application.
#    To generate a Sandbox API Certificate, follow these steps: https://www.paypal.com/IntegrationCenter/ic_certificate.html
###############################################################################################################################
    payment_settings = PaymentSetting.find(1)
    @@credentials =  {"USER" => payment_settings.paypal_api_user_name, "PWD" => payment_settings.paypal_api_password, "SIGNATURE" => payment_settings.paypal_api_signature }  
    @@endpoints = {"SERVER" => "api-3t.paypal.com", "SERVICE" => "/nvp/"}
    @@proxy_info = {"USE_PROXY" => false, "ADDRESS" => nil, "PORT" => nil, "USER" => nil, "PASSWORD" => nil }
    @@client_info = { "VERSION" => "3.0", "SOURCE" => "PayPalRubySDKV1.0"}       
  end    
end