class AddSlackDataToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :slack_id, :string
    add_column :companies, :slack_access_token, :text
    add_column :companies, :slack_bot_user_id, :string
    add_column :companies, :slack_bot_access_token, :text
    add_column :employments, :archived, :boolean, default: false
    add_column :employments, :slack_dm_channel_id, :string
  end
end
