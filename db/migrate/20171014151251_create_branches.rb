class CreateBranches < ActiveRecord::Migration[5.1]
  def change
    create_table :branches do |t|

      t.string   :name
      t.string   :address
      t.string   :coordinates
      t.decimal  :rating
      t.integer  :rating_number
      t.string   :postalcode
      t.string   :district
      t.string   :area

      t.timestamps
      t.references :business, foreign_key: true

    end
  end
end
