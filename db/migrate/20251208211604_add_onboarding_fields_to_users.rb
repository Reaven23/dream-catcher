class AddOnboardingFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :pays, :string
    add_column :users, :rappel_reves, :string
    add_column :users, :reves_lucides, :string
    add_column :users, :heure_sommeil, :string
    add_column :users, :stress_niveau, :integer
    add_column :users, :humeur_generale, :string
    add_column :users, :source_stress, :jsonb
    add_column :users, :situation_pro, :string
    add_column :users, :changements_recents, :jsonb
    add_column :users, :symbolisme, :string
    add_column :users, :vision_reves, :string
    add_column :users, :peurs_principales, :text
    add_column :users, :emotions_recurrentes, :text
    add_column :users, :ton_prefere, :string
    add_column :users, :longueur_analyse, :string
    add_column :users, :style_prefere, :string
    add_column :users, :onboarding_completed, :boolean, default: false
  end
end
