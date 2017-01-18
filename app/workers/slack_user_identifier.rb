class SlackUserIdentifier
  include Sidekiq::Worker

  def perform(company_id)
    @company = Company.find(company_id)
    create_or_update_employees!
  end

  private

  def create_or_update_employees!
    users_data = @company.bot_client.users_list
    users_data.each do |user_data|
      SlackUserBuilder.new(@company, user_data).create_or_update!
    end
  end
end
