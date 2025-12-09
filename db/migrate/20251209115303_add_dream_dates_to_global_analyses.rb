class AddDreamDatesToGlobalAnalyses < ActiveRecord::Migration[7.1]
  def change
    add_column :global_analyses, :first_dream_date, :date
    add_column :global_analyses, :last_dream_date, :date
  end
end
