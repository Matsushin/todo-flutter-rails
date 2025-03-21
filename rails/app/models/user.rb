# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
end
