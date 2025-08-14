class User < ApplicationRecord
  has_secure_password   # ← これで bcrypt によるハッシュ化＆authenticateが使える
  validates :name,  presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, allow_nil: true
end
