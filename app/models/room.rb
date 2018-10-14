class Room < ApplicationRecord
  has_many :tobanhyos
  has_secure_password validations: true

  validates :login_id, presence: true, uniqueness: true
  validates :password, confirmation: true

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end
end
