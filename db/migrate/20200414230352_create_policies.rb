class CreatePolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :policies do |t|
      t.integer :group_id, null: false
      t.timestamp :effective_date, null: false
      t.timestamp :expiration_date, null: false
      t.integer :policy_number, null: false
      
      t.timestamps 
    end
  end
end
