class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :short_name
      t.string :contact
      t.string :phone
      t.string :cell
      t.string :address
      t.string :web
      t.text :product_supplied
      t.integer :input_by_id
      t.text :main_biz
      t.date :supply_since
      t.date :last_eval_date
      t.text :eval_summary
      t.text :customer_service

      t.timestamps
    end
  end
end
