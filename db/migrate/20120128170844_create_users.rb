class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :name
      t.string :email
      t.string :encrypted_password
      t.string :salt
      t.string :status, :default => 'active'
      t.string :user_type
      t.integer :input_by_id

      t.timestamps
    end
  end
end
