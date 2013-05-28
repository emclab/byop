class CreateShipmentItems < ActiveRecord::Migration
  def change
    create_table :shipment_items do |t|
      t.integer :shipment_id
      t.integer :input_by_id
      t.string :name
      t.string :spec
      t.integer :qty
      t.string :unit
      t.text :brief_note
      t.boolean :box, :default => false

      t.timestamps
    end
  end
end
