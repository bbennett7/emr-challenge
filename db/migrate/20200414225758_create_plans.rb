class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.integer :provider_id, null: false
      t.string :plan_name, null: false
      t.string :plan_type
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end
