class RenameCancellDateInProjects < ActiveRecord::Migration
  change_table :projects do |t|
    t.rename :cancell_date, :cancel_date
  end
end
