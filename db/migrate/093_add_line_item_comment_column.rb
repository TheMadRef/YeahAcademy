class AddLineItemCommentColumn < ActiveRecord::Migration
  def self.up
    add_column :line_items, :comment, :string
  end

  def self.down
    remove_column :line_items, :comment
  end
end
