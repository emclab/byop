class CreateInstallationPurchases < ActiveRecord::Migration
  def change
    create_table :installation_purchases do |t|
      t.integer :installation_id
      t.integer :input_by_id
      t.integer :applicant_id
      t.string :part_name
      t.string :spec
      t.decimal :qty, :precision => 6, :scale => 2
      t.string :unit
      t.decimal :unit_price, :precision => 8, :scale => 2
      t.decimal :total, :precision => 8, :scale => 2
      t.text :for_what
      t.decimal :qty_purchased, :precision => 6, :scale => 2
      t.decimal :total_paid, :precision => 8, :scale => 2
      t.decimal :qty_in_stock, :precision => 6, :scale => 2
      t.boolean :approved_by_vp_eng
      t.integer :approve_vp_eng_id
      t.date :approve_date_vp_eng
      t.boolean :approved_by_ceo
      t.integer :approve_ceo_id
      t.date :approve_date_ceo
      t.string :storage_location
      t.boolean :purchased, :default => false
      t.date :need_date

      t.timestamps
    end
  end
end
