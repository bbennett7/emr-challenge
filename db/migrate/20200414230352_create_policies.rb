class CreatePolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :policies do |t|
      t.integer :group_id, null: false
      t.timestamps :effective_date, null: false
      t.timestamps :expiration_date, null: false
      t.integer :policy_number, null: false
      
      t.timestamps 
    end
  end
end
