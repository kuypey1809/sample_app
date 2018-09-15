class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password
  validates :name,  presence: true, length: {maximum: Settings.name.max_size}
  validates :email, presence: true, length: {maximum: Settings.email.max_size},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.pass.min_size}
  before_save ->{email.downcase!}
end
