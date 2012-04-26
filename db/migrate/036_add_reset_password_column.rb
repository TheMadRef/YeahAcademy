class AddResetPasswordColumn < ActiveRecord::Migration
  def self.up
    add_column :users, :reset_password, :string
  end

  def self.down
    remove_column :users, :reset_password
  end
end
