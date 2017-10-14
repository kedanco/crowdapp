class CreateCrowdLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :crowd_levels do |t|

      t.integer :hour
      t.string :day
      t.integer :density

      t.references :branch, foreign_key: true
      t.timestamps
    end
  end
end
