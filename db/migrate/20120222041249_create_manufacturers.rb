class CreateManufacturers < ActiveRecord::Migration
  def change
    create_table :manufacturers do |t|
      t.string :name
      t.integer :input_by_id
      t.string :product

      t.timestamps
    end
  end
end
