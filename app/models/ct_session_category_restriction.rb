class CtSessionCategoryRestriction < ActiveRecord::Base

  validates_presence_of :category_id, :ct_session_id
  validates_uniqueness_of :category_id, :scope => :ct_session_id

end
