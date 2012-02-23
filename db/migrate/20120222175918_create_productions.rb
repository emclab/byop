class CreateProductions < ActiveRecord::Migration
  def change
    create_table :productions do |t|
      t.string :name
      t.text :desp
      t.integer :project_id
      t.date :start_date
      t.date :finish_date
      t.integer :eng_id
      t.boolean :completed, :default => false
      t.integer :input_by_id

      t.timestamps
    end
  end
end
