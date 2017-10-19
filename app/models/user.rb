class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :login

  validates :username,
            presence: true,
            uniqueness: {
              case_sensitive: false
            }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true

  validate :validate_username

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }]).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_h).first
    end
  end

  private

  def validate_username
    errors.add(:username, :invalid) if User.where(email: username).exists?
  end
end
