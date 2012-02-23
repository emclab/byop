class CreateSourcings < ActiveRecord::Migration
  def change
    create_table :sourcings do |t|
      t.string :prod_name
      t.string :part_num
      t.text :spec
      t.integer :qty
      t.string :unit
      t.decimal :unit_price, :precision => 10, :scale => 2
      t.integer :subsys_id
      t.integer :src_plant_id
      t.date :start_date
      t.date :finish_date
      t.boolean :completed, :default => false
      t.integer :eng_id
      t.integer :input_by_id
      t.boolean :approved_by_vp_eng
      t.integer :approve_vp_eng_id
      t.date :approve_date_vp_eng
      t.boolean :approved_by_ceo
      t.integer :approve_ceo_id
      t.date :approve_date_ceo

      t.timestamps
    end
  end
end
