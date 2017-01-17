class Employment < ApplicationRecord
  belongs_to :company
  belongs_to :user
  delegate :slack_client, to: :company
end
