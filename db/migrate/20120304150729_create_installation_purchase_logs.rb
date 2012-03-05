class CreateInstallationPurchaseLogs < ActiveRecord::Migration
  def change
    create_table :installation_purchase_logs do |t|
      t.integer :installation_purchase_id
      t.integer :input_by_id
      t.text :log

      t.timestamps
    end
  end
end
