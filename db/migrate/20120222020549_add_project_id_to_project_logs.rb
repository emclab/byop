class AddProjectIdToProjectLogs < ActiveRecord::Migration
  def change
    add_column :project_logs, :project_id, :integer
  end
end
