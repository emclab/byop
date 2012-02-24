class CreatePurchasings < ActiveRecord::Migration
  def change
    create_table :purchasings do |t|
      t.string :prod_name
      t.string :part_num
      t.string :spec
      t.integer :project_id
      t.integer :qty
      t.string :unit
      t.decimal :unit_price, :precision => 10, :scale => 2
      t.integer :eng_id
      t.integer :manufacturer_id
      t.integer :supplier_id
      t.date :order_date
      t.date :delivery_date
      t.boolean :delivered, :default => false
      t.integer :subsys_id
      t.integer :input_by_id
      t.boolean :approved_by_eng
      t.integer :approve_eng_id
      t.date :approve_date_eng
      t.boolean :approved_by_vp_eng
      t.integer :approve_vp_eng_id
      t.date :approve_date_vp_eng
      t.boolean :approved_by_pur_eng
      t.integer :approve_pur_eng_id
      t.date :approve_date_pur_eng
      t.boolean :approved_by_ceo
      t.integer :approve_ceo_id
      t.date :approve_date_ceo

      t.timestamps
    end
  end
end
