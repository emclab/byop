class CreateProductionLogs < ActiveRecord::Migration
  def change
    create_table :production_logs do |t|
      t.integer :production_id
      t.text :log
      t.integer :input_by_id

      t.timestamps
    end
  end
end
