class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password
  before_save :email_downcase
  validates :name, presence: true, length: {maximum: Settings.user_name.max_length}
  validates :email, presence: true, length: {maximum: Settings.email.max_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.password.min_length}

  private

  def email_downcase
    self.email = email.downcase
  end
end
