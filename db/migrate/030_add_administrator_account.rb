class AddAdministratorAccount < ActiveRecord::Migration
  def self.up
		User.create(:login => 'administrator',
		:crypted_password => 'de422c2aaa7197fe783ccdbe63782d2efce96ff6',
		:salt => 'e67c218199ebf0702a9d8e05ea4d04f900811163',
		:admin => 1)
  end

  def self.down
		User.find(:first, :conditions => ["login = ? AND crypted_password = ?", 'administrator', 'de422c2aaa7197fe783ccdbe63782d2efce96ff6']).destroy
  end
end
