class CreateDistricts < ActiveRecord::Migration[5.1]
  def change
    create_table :districts do |t|

      t.string  :name
      t.decimal :lat, precision:15, scale:10
      t.decimal :lng, precision:15, scale:10

      t.references :area, foreign_key: true
      t.timestamps
    end
  end
end
