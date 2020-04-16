class CreatePlanMappers < ActiveRecord::Migration[6.0]
  def change
    create_table :plan_mappers do |t|
      t.integer :plan_id, null: false
      t.integer :provider_id, null: false
      t.string :source_name, null: false
      t.string :source_plan_name, null: false
      t.string :source_plan_id, null: false

      t.timestamps
    end
  end
end
