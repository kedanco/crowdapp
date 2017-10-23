class AddPlaceReference < ActiveRecord::Migration[5.1]
  def change
      add_reference :places, :district, index: true
  end
end
