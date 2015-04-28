class User < ActiveRecord::Base
  authenticates_with_sorcery!
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  validates :email, presence: true,
			  :format => { :with => VALID_EMAIL_REGEX}
  validates_uniqueness_of :email

end
