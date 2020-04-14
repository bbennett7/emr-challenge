class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.integer :provider_id
      t.integer :plan_id
      t.integer :group_number
      t.string :group_name

      t.timestamps
    end
  end
end
