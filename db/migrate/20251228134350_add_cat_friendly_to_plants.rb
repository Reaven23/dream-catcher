class AddCatFriendlyToPlants < ActiveRecord::Migration[7.1]
  def change
    add_column :plants, :cat_friendly, :text
  end
end
