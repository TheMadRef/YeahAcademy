class FeeLog < ActiveRecord::Base
  has_one :line_item
  belongs_to :participant

  validates_presence_of :participant_id, :message => "could not be found in participant database"
  validates_numericality_of :amount
  
  def validate
    errors.add(:amount, "should be at least 0.01" ) if amount.nil? || amount < 0.01
  end
end
