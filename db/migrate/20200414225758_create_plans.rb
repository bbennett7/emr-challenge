class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.integer :provider_id, null: false
      t.string :plan_name, null: false
      t.string :id_type
      t.string :plan_type
      t.string :provider_plan_id, null: false

      t.timestamps
    end
  end
end
