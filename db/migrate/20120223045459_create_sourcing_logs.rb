class CreateSourcingLogs < ActiveRecord::Migration
  def change
    create_table :sourcing_logs do |t|
      t.integer :sourcing_id
      t.text :log
      t.integer :input_by_id

      t.timestamps
    end
  end
end
