class RtMemo < ActiveRecord::Base
  has_many :rt_memo_user_group_relationships, :dependent => :destroy
  
  upload_column :memo_file

  validates_presence_of :memo_title
  validates_uniqueness_of :memo_title
  validates_size_of :memo_file, :maximum => 1100000, :message => "is too big, must be smaller than 1MB", :if => :validate_file_size

  def validate_file_size
    if !memo_file.nil?
      return true
    else
      return false    
    end
  end
end
