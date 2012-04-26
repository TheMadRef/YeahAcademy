class Category < ActiveRecord::Base
	has_many :participants, :dependent => :nullify
	has_many :ct_session_category_restrictions, :dependent => :destroy
  belongs_to :category, :foreign_key => "parent_id"
	
  validates_presence_of :category_name
  validates_uniqueness_of :category_name, :scope => [:parent_id]
	
  def self.sorted_category_array
    array = []
    categories_for_array = find(:all, :conditions => ["parent_id = ?", 0], :order => "category_name ASC")
    for category in categories_for_array
      array << category.id
      sub_categories_for_array = find(:all, :conditions => ["parent_id = ?", category.id], :order => "category_name ASC")
      if !sub_categories_for_array.nil?
        for sub_category in sub_categories_for_array
          array << sub_category.id
        end
      end
    end
    return array
  end
  
  def self.sorted_category_for_select
    category_list = []
    categories_for_select = find(:all, :conditions => ["parent_id = ?", 0], :order => "default_category DESC, category_name ASC")
    for category in categories_for_select
      category_list << [category.category_name, category.id]
      sub_categories_for_select = find(:all, :conditions => ["parent_id = ?", category.id], :order => "category_name ASC")
      if !sub_categories_for_select.nil?
        for sub_category in sub_categories_for_select
          category_list << ["#{sub_category.category.category_name}:#{sub_category.category_name}", sub_category.id]
        end
      end
    end
    return category_list
  end

	def self.print_category_name(category_id) 
		category = find_by_id(category_id)
		if category.parent_id == 0
			return category.category_name
		else
			return category.category.category_name + ":" + category.category_name
		end
	end
end
