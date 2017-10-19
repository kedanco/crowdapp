class ChangeType < ActiveRecord::Migration[5.1]
  def change
    rename_column :places, :type, :place_type
  end
end
