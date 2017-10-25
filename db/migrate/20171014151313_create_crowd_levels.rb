class CreateCrowdLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :crowd_levels do |t|

      t.integer :hour
      t.string :day
      t.integer :crowd_density

      t.references :place, foreign_key: true
      t.references :district, foreign_key: true
      t.references :area, foreign_key: true
      t.timestamps
    end
  end
end
