class Inquiry < ApplicationRecord
  belongs_to :question
  belongs_to :employment

  scope :undelivered, -> { where(delivered_at: nil) }
end
