class AddProjectIdToInstallationss < ActiveRecord::Migration
  def change
    add_column :installations, :project_id, :integer
  end
end
