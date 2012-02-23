class AddAwardedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :awarded, :boolean
  end
end
