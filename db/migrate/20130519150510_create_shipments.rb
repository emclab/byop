class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.integer :project_id
      t.integer :input_by_id
      t.date :shipping_date
      t.text :freight_desp
      t.string :shipping_via
      t.string :status
      t.date :delivery_date
      t.boolean :approved_by_ceo
      t.integer :approve_ceo_id
      t.date :approve_date_ceo
      t.boolean :cancelled, :default => false
      t.string :customer_signature_by
      t.text :delivery_address
      t.integer :weight
      t.text :packing_desp
      t.string :carrier

      t.timestamps
    end
  end
end
