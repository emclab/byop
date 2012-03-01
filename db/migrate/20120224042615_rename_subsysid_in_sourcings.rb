class RenameSubsysidInSourcings < ActiveRecord::Migration
  change_table :sourcings do |t|
    t.rename :subsys_id, :proj_module_id
  end
end
