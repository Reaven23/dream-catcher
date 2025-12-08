class Dream < ApplicationRecord
  belongs_to :user
  has_one :analysis, dependent: :destroy

  validates :content, presence: true
  validates :date, presence: true

  # Le titre est généré automatiquement par l'IA si non fourni
  before_save :set_default_title, if: -> { title.blank? }

  scope :recent, -> { order(date: :desc) }

  private

  def set_default_title
    self.title = "Rêve du #{date.strftime('%d/%m/%Y')}"
  end
end
