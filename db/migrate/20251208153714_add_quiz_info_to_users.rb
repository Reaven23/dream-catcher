class AddQuizInfoToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :zodiac_sign, :string
    add_column :users, :age, :integer
    add_column :users, :relationship_status, :string
    add_column :users, :gender, :string
  end
end
