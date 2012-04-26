class CreateImExcelControls < ActiveRecord::Migration
  def self.up
    create_table :im_excel_controls do |t|
    	t.column :control_name, :string
    	t.column :control_type, :string
    	t.column :file_name, :string
    	t.column :sport_cell, :string
    	t.column :date_cell, :string
    	t.column :time_cell, :string
    	t.column :field_cell, :string
    	t.column :division_cell, :string
    	t.column :league_cell, :string
    	t.column :home_team_cell, :string
    	t.column :home_color_cell, :string
    	t.column :away_team_cell, :string
    	t.column :away_color_cell, :string
    	t.column :home_id_cell, :string
    	t.column :home_roster_cell, :string
    	t.column :away_id_cell, :string
    	t.column :away_roster_cell, :string
    	t.column :line_space, :integer
    	t.column :roster_spots, :integer
    	t.column :header_cell, :string
    	t.column :column_factor, :integer
    	t.column :row_factor, :integer
    	t.column :worksheet_number, :integer
    end
  end

  def self.down
    drop_table :im_excel_controls
  end
end
