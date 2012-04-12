class AddCancellDateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :cancell_date, :datetime
  end
end
