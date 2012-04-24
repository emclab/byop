class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.string :name
      t.datetime :in_date
      t.decimal :in_qty, :precision => 8, :scale => 1
      t.string :spec
      t.integer :input_by_id
      t.decimal :stock_qty, :precision => 8, :scale => 1
      t.string :manufacturer
      t.text :note
      t.string :storage_location
      t.string :inspection

      t.timestamps
    end
  end
end
