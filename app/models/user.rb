class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :dreams, dependent: :destroy
  has_many :analyses, through: :dreams

  # Validations pour le quiz (appliquées seulement lors de la mise à jour du quiz)
  validates :first_name, presence: true, if: :validating_quiz?
  validates :zodiac_sign, presence: true, if: :validating_quiz?
  validates :age, presence: true, numericality: { greater_than: 0 }, if: :validating_quiz?

  attr_accessor :validating_quiz

  def quiz_completed?
    first_name.present? && zodiac_sign.present? && age.present?
  end

  def validating_quiz?
    validating_quiz == true
  end
end
