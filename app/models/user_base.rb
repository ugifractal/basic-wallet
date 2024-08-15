class UserBase < ApplicationRecord
  self.table_name = "users"

  has_secure_password
  has_one :wallet, dependent: :destroy, foreign_key: :user_id
  has_one :portfolio, dependent: :destroy, foreign_key: :user_id

  validates :email, uniqueness: true
  validates :email, presence: true
  validates :api_key, uniqueness: true

  before_create :generate_api_key
  after_create :generate_portfolio!
  after_create :generate_wallet!

  private

  def generate_portfolio!
    new_portfolio = build_portfolio
    new_portfolio.save!
  end

  def generate_wallet!
    new_wallet = build_wallet
    new_wallet.save!
  end

  def generate_api_key
    self.api_key = SecureRandom.urlsafe_base64
  end
end
