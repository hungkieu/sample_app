class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password

  before_save :email_downcase, :activation_token
  before_create :create_activation_digest

  validates :name, presence: true, length: {maximum: Settings.user_name.max_length}
  validates :email, presence: true, length: {maximum: Settings.email.max_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.password.min_length}, allow_nil: true

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MINCOST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
    SecureRandom.urlsafe_base64
    end
  end

  def current_user? user
    self == user
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def activate
    update_attributes activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def email_downcase
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest self.activation_token
  end
end
