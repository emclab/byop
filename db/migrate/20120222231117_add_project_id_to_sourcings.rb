class AddProjectIdToSourcings < ActiveRecord::Migration
  def change
    add_column :sourcings, :project_id, :integer
  end
end
