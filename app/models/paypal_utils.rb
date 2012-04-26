require 'log4r'
require 'singleton'
module PayPalSDKUtils 
class Logger  
    include Singleton
    cattr_accessor :MyLog
    def self.getLogger(filename)
      @@MyLog = Log4r::Logger.new("paypallog")
      # note: change the file name path, mainly RAILS_ROOT if you are not runnig under rails application
      Log4r::FileOutputter.new('paypal_log',
                       :filename=> "#{RAILS_ROOT}/log/#{filename}",
                       :trunc=>false,
                       :formatter=> MyFormatter)
      @@MyLog.add('paypal_log')
      return @@MyLog
      end  
  end
  
class MyFormatter < Log4r::Formatter
    def format(event)
      buff = Time.now.strftime("%a %m/%d/%y %H:%M %Z")
      buff += " - #{Log4r::LNAMES[event.level]}"
      buff += " - #{event.data}\n"
    end
  end  
  
end