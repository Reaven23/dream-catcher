class GlobalAnalysis < ApplicationRecord
  belongs_to :user

  validates :interpretation, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
