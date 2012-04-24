class AddPartIdToOutLogs < ActiveRecord::Migration
  def change
    add_column :out_logs, :part_id, :integer
  end
end
