class AddInputByIdToOutLogs < ActiveRecord::Migration
  def change
    add_column :out_logs, :input_by_id, :integer
  end
end
