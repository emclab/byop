class CreateInstallationLogs < ActiveRecord::Migration
  def change
    create_table :installation_logs do |t|
      t.integer :installation_id
      t.text :log
      t.integer :input_by_id

      t.timestamps
    end
  end
end
