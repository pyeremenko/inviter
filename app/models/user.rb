# Represents a user registered in the system.
class User < ApplicationRecord
  validates_presence_of :name, :email, :password_digest
  validates :email, uniqueness: true

  has_secure_password

  def info
    { name: name, email: email }
  end
end
