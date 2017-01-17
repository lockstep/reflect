class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :employments
  has_many :companies, through: :employments

  def company
    # NOTE: Allow for multiple companies in the future.
    companies.first
  end
end
