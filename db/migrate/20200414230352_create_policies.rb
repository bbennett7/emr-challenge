class CreatePolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :policies do |t|
      t.integer :group_id
      t.timestamps :effective_date
      t.timestamps :expiration_date
      t.integer :policy_number
      
      t.timestamps 
    end
  end
end
