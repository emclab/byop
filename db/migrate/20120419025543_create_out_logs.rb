class CreateOutLogs < ActiveRecord::Migration
  def change
    create_table :out_logs do |t|
      t.datetime :out_date
      t.integer :receiver_id
      t.integer :out_qty
      t.integer :project_id
      t.string :for_what

      t.timestamps
    end
  end
end
