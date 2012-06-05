class CreateSysLogs < ActiveRecord::Migration
  def change
    create_table :sys_logs do |t|
      t.datetime :log_date
      t.integer :user_id
      t.string :user_name
      t.string :user_ip
      t.string :action_logged

    end
    add_index :sys_logs, :user_id, :name => "index_sys_logs_on_user_id"
    add_index :sys_logs, :user_ip, :name => "index_sys_logs_on_user_ip"
  end
end
