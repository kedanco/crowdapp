class ChangePlacesCrowdlevelColumns < ActiveRecord::Migration[5.1]
  def change
      remove_column :places, :district
      remove_column :places, :area
      rename_column :crowd_levels, :density, :crowd_density
  end
end
