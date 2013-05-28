class CreateBoxItems < ActiveRecord::Migration
  def change
    create_table :box_items do |t|
      t.integer :shipment_item_id
      t.string :name
      t.string :spec
      t.integer :qty
      t.string :unit
      t.text :brief_note
      t.integer :input_by_id

      t.timestamps
    end
  end
end
