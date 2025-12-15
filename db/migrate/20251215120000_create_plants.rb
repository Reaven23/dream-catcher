class CreatePlants < ActiveRecord::Migration[7.1]
  def change
    create_table :plants do |t|
      t.references :user, null: false, foreign_key: true

      t.string :name, null: false
      t.text :description

      t.string :sun_need
      t.string :water_need
      t.string :soil_need
      t.string :wind_need
      t.text :other_needs

      t.timestamps
    end
  end
end
