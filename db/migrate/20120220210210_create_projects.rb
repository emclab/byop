class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :customer_id
      t.string :status
      t.date :contract_date
      t.date :start_prod_date
      t.date :construction_finish_date
      t.date :install_start_date
      t.date :test_run_date
      t.date :turn_over_date
      t.text :tech_spec
      t.string :install_address
      t.integer :input_by_id
      t.string :budget
      t.text :construction_requirement
      t.string :tonnage
      t.text :subsys_spec
      t.text :other_tech_requirement
      t.text :test_run_requirement
      t.text :turn_over_requirement
      t.boolean :completed
      t.boolean :cancelled
      t.text :note
      t.text :review_after

      t.timestamps
    end
  end
end
