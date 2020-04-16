class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.integer :provider_id, null: false
      t.integer :plan_id
      t.string :group_number, null: false
      t.string :group_name, null: false

      t.timestamps
    end
  end
end
