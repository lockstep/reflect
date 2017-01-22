class Employment < ApplicationRecord
  belongs_to :company
  belongs_to :user
  delegate :bot_client, to: :company

  def send_message(message)
    bot_client.send_message(self, message)
  end
end
