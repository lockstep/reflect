class Employment < ApplicationRecord
  belongs_to :company
  has_many :questions, through: :company
  belongs_to :user
  has_many :inquiries
  delegate :bot_client, to: :company

  def admin?
    role == 'admin'
  end

  def send_message(message)
    bot_client.send_message(self, message)
  end

  def schedule_inquiry!
    week_start = local_time.at_beginning_of_week
    unless inquiries.where('to_be_delivered_at > ?', week_start)
      .where('to_be_delivered_at < ?', week_start.advance(weeks: 1)).empty?
      return
    end
    inquiries.create(
      question: optimal_question, to_be_delivered_at: optimal_time_for_inquiry
    )
  end

  def optimal_question
    questions.order("RANDOM()").first
  end

  def optimal_time_for_inquiry
    schedulable_hours_in_week = 40
    schedulable_hours_in_day = 8
    work_hours_from_now = Random.new.rand(schedulable_hours_in_week)
    optimal_time = local_time.at_beginning_of_week.advance(hours: 9)
    work_days_to_advance = work_hours_from_now / schedulable_hours_in_day
    # For hours 8, 16, etc. we want the day before.
    if work_hours_from_now > 0 &&
        work_hours_from_now % schedulable_hours_in_day == 0
      work_days_to_advance -= 1
    end
    optimal_time.advance(days: work_days_to_advance)
    optimal_time.advance(hours: work_hours_from_now % schedulable_hours_in_day)
  end

  private

  def local_time
    Time.now.in_time_zone(time_zone)
  end

end
