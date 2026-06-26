class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :expenses

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :locale, with: ->(l) { l.to_sym }

  validates :locale, inclusion: { in: I18n.available_locales }, allow_nil: true
end
