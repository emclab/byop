class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :short_name
      t.text :contact_info
      t.string :address
      t.string :country
      t.string :phone
      t.string :fax
      t.string :email
      t.string :web
      t.boolean :active, :default => true
      t.integer :input_by_id
      t.string :quality_system
      t.string :employee_num
      t.string :revenue
      t.text :main_biz
      t.text :equip_by_by
      t.text :installed_equip
      t.text :note

      t.timestamps
    end
  end
end
