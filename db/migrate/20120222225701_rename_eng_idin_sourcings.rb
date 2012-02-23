class RenameEngIdinSourcings < ActiveRecord::Migration
  change_table :sourcings do |t|
    t.rename :eng_id, :src_eng_id
  end
end
