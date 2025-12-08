class CreateAnalyses < ActiveRecord::Migration[7.1]
  def change
    create_table :analyses do |t|
      t.references :dream, null: false, foreign_key: true
      t.text :interpretation

      t.timestamps
    end
  end
end
