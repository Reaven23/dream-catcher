class AddDreamsCountToGlobalAnalyses < ActiveRecord::Migration[7.1]
  def change
    add_column :global_analyses, :dreams_count, :integer
  end
end
