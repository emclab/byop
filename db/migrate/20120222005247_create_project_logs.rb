class CreateProjectLogs < ActiveRecord::Migration
  def change
    create_table :project_logs do |t|
      t.text :log
      t.integer :input_by_id
      t.string :subject

      t.timestamps
    end
  end
end
