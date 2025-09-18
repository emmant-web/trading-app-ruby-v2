class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  before_create :set_default_balance

  # ransack
  def self.ransackable_attributes(auth_object = nil)
    [
      "email",
      "first_name", 
      "last_name",
      "is_pending",
      "is_admin"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["stocks", "transactions"]
  end

  # associations
  has_many :transactions
  has_many :stocks

  scope :traders, -> { where(is_admin: false) }
  scope :pending, -> { where(is_pending: true) }

  # validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :balance, presence: true, numericality: true, if: :is_admin?
  
  private

  def set_default_balance
    self.balance ||= 100_000.0
  end
end
