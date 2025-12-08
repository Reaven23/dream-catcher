class CreateGlobalAnalyses < ActiveRecord::Migration[7.1]
  def change
    create_table :global_analyses do |t|
      t.references :user, null: false, foreign_key: true
      t.text :interpretation

      t.timestamps
    end
  end
end
