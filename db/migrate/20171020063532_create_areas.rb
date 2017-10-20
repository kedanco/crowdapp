class CreateAreas < ActiveRecord::Migration[5.1]
  def change
    create_table :areas do |t|

      t.string  :name
      t.decimal :lat, precision:15, scale:10
      t.decimal :lng, precision:15, scale:10
      t.integer :crowd_density

      t.timestamps
    end
  end
end
