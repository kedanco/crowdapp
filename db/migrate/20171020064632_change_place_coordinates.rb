class ChangePlaceCoordinates < ActiveRecord::Migration[5.1]
  def change
      remove_column :places, :coordinates
      add_column    :places, :lat, :decimal, precision:15, scale:10
      add_column    :places, :lng, :decimal, precision:15, scale:10
  end
end
