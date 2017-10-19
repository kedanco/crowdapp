class ChangeDistrict < ActiveRecord::Migration[5.1]
  def change
    change_column :places, :district, 'integer USING CAST(district AS integer)'
  end
end
