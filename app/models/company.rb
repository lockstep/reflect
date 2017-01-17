class Company < ApplicationRecord

  has_many :employments
  has_many :questions

  def add_admin(user)
    Employment.create(
      company: self, user: user, email: user.email, role: :admin
    )
  end

  def add_employee(email, slack_handle)
    user = User
      .create_with(password: Devise.friendly_token)
      .find_or_create_by(email: email)

    Employment.create(
      company: self, email: email, slack_handle: slack_handle, user: user
    )
  end

  def slack_client
    SlackWebApiClient.new(ENV['SLACK_TOKEN'])
  end

  def get_question_for(employment)
    Question.first
  end
end
