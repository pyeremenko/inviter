# Represents a user registered in the system.
class User < ApplicationRecord
  validates_presence_of :name, :email, :password_digest
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_secure_password
  has_one :invite

  def to_h
    { name: name, email: email, credits: credits.to_i }
  end
end
