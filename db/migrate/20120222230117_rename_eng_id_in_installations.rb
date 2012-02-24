class RenameEngIdInInstallations < ActiveRecord::Migration
  change_table :installations do |t|
    t.rename :eng_id, :inst_eng_id
  end
end
