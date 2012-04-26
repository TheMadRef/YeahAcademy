class TermAddImtrackId < ActiveRecord::Migration
  def self.up
    add_column :terms, :imtrack_id, :integer
  end

  def self.down
    remove_column :terms, :imtrack_id
  end
end
