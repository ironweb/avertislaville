class AddDistrictAndToken < ActiveRecord::Migration
  def change
    add_column :events, :token, :string

    add_column :events, :district_id, :integer
    add_column :events, :area_id, :integer

    add_index :events, :token
    add_index :events, :district_id
    add_index :events, :area_id
  end
end
