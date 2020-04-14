class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.integer :policy_id
      t.integer :group_id
      t.integer :plan_id
      t.integer :provider_id
      t.integer :member_number
      t.string :first_name
      t.string :last_name
      t.string :ssn_encrypted
      t.timestamps :date_of_birth
      t.boolean :sex, default:  null
      t.integer :member_number
      t.string :street_address
      t.string :city
      t.string :state 
      t.string :zip
      t.string :county 
      t.string :country

      t.timestamps
    end
  end
end
