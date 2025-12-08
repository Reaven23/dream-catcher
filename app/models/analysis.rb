class Analysis < ApplicationRecord
  belongs_to :dream
  has_one :user, through: :dream

  validates :interpretation, presence: true
end
