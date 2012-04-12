class ChangeProjects < ActiveRecord::Migration
  change_table :projects do |t|
    t.remove :construction_requirement, :test_run_requirement, :test_run_date, :turn_over_date
    t.date :design_start_date
  end
end
