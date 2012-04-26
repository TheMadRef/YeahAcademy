class DesktopUser < ActiveRecord::Base
	has_one :im_desktop_user_option, :dependent => :destroy
	has_many :im_serial_number, :dependent => :nullify
end
