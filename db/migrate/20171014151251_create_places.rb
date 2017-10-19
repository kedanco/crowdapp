class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|

      t.string   :name
      t.string   :address
      t.string   :coordinates
      t.string   :type
      t.decimal  :rating
      t.integer  :rating_number
      t.string   :postalcode
      t.string   :district
      t.string   :area

      t.timestamps


    end
  end
end
