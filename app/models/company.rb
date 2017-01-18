class Company < ApplicationRecord

  has_many :employments, -> { where(archived: false) }
  has_many :questions

  def add_admin(user)
    Employment.create(
      company: self, user: user, email: user.email, role: :admin
    )
  end

  def add_employee(email, slack_id)
    user = User
      .create_with(password: Devise.friendly_token)
      .find_or_create_by(email: email)

    Employment.create(
      company: self, email: email, slack_id: slack_id, user: user
    )
  end

  def bot_client
    SlackWebApiClient.new(slack_bot_access_token)
  end

  def get_question_for(employment)
    Question.first
  end
end
