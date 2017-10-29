class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|

      t.string   :name
      t.string   :address
      t.decimal  :lat, precision:15, scale:10
      t.decimal  :lng, precision:15, scale:10
      t.string   :place_type
      t.decimal  :rating
      t.integer  :rating_number
      t.string   :postalcode

      t.timestamps

      t.references :district, foreign_key: true
    end
  end
end
