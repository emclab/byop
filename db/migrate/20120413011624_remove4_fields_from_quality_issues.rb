class Remove4FieldsFromQualityIssues < ActiveRecord::Migration
  change_table :quality_issues do |t|
    t.remove :production_id, :installation_id, :purchasing_id, :sourcing_id
  end
end
