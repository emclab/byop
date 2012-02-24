class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :customer_id
      t.text :customer_contact_info      
      t.string :status
      t.string :install_address
      t.string :budget
      t.string :tonnage      
      t.text :tech_spec
      t.text :subsys_spec
      t.text :other_tech_requirement 
      t.text :construction_requirement
      t.text :test_run_requirement
      t.text :turn_over_requirement  
      t.date :bid_doc_available_date   
      t.date :bid_deadline 
      t.date :bid_opening_date     
      t.date :contract_date
      t.date :production_start_date
      t.date :construction_finish_date
      t.date :install_start_date
      t.date :test_run_date
      t.date :turn_over_date
      t.boolean :completed, :default => false
      t.boolean :cancelled, :default => false
      t.text :note
      t.text :review_after
      t.integer :input_by_id      

      t.timestamps
    end
  end
end
