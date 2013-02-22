class CreateEvent < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.column :type_code, :string
      t.timestamps
      t.point :lonlat
    end
  end
end
