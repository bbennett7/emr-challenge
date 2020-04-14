class CreateProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :providers do |t|
      t.string :provider_name, null: false
      t.string :street_address
      t.string :city
      t.string :state 
      t.string :zip 
      t.string :county
      t.string :country
      t.string :phone_number

      t.timestamps
    end
  end
end
