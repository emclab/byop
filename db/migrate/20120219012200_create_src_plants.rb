class CreateSrcPlants < ActiveRecord::Migration
  def change
    create_table :src_plants do |t|
      t.string :name
      t.string :short_name
      t.string :address
      t.string :primary_contact
      t.string :primary_cell
      t.string :phone
      t.string :tech_contact
      t.string :tech_cell
      t.text :tech_ability
      t.text :customer_service
      t.text :production_capacity
      t.text :sourced_product
      t.text :equip
      t.date :last_eval_date
      t.text :eval_summary
      t.string :quality_system
      t.string :employee_num
      t.text :about_us
      t.boolean :active, :default => true
      t.string :revenue
      t.date :src_since

      t.timestamps
    end
  end
end
