class AddTimeZoneToEmployments < ActiveRecord::Migration[5.0]
  def change
    add_column :employments, :time_zone, :string
  end
end
