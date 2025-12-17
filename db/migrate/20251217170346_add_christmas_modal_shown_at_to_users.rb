class AddChristmasModalShownAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :christmas_modal_shown_at, :datetime
  end
end
