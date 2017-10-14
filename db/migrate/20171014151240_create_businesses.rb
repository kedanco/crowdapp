class CreateBusinesses < ActiveRecord::Migration[5.1]
  def change
    create_table :businesses do |t|

      t.string :name

      t.references :business_category, foreign_key: true
    end
  end
end
