class Dream < ApplicationRecord
  belongs_to :user
  has_one :analysis, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
  validates :date, presence: true

  scope :recent, -> { order(date: :desc) }
end
