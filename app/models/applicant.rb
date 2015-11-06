class Applicant < ActiveRecord::Base
  PHONE_TYPES = [
      'iPhone 6/6 Plus',
      'iPhone 6s/6s Plus',
      'iPhone 5/5S',
      'iPhone 4/4S',
      'iPhone 3G/3GS',
      'Android 4.0+ (less than 2 years old)',
      'Android 2.2/2.3 (over 2 years old)',
      'Windows Phone',
      'Blackberry',
      'Other'
  ]
  REGIONS = [
      'San Francisco Bay Area',
      'Chicago',
      'Boston',
      'NYC',
      'Toronto',
      'Berlin',
      'Delhi'
  ]
  WORKFLOW_STATES = [
      'applied',
      'quiz_started',
      'quiz_completed',
      'onboarding_requested',
      'onboarding_completed',
      'hired',
      'rejected'
  ]

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, uniqueness: true
  validates :phone_type, presence: true
  validates :workflow_state, presence: true
  validates :region, presence: true

  before_validation :set_default_workflow_state, on: :create

  state_machine :state, initial: :base do
    event :next_step do
      transition base: :background_check
      transition background_check: :complete
    end

    state :base
    state :background_check
    state :complete
  end

  class << self

    def funnel_histogram(start_date:, end_date:)
      start_date = start_date.beginning_of_day
      end_date   = end_date.end_of_day

      week_interval = "DATE_TRUNC('week', created_at)::date"
      result = Applicant.where(created_at: (start_date..end_date))
                        .group(week_interval, :workflow_state)
                        .order(week_interval)
                        .count

      funnel_result_serializer(result)
    end

    private

    def funnel_result_serializer(result)
      hash = Hash.new { |h, k| h[k] = {} }
      result.each do |object, count|
        st_of_week = object[0]
        ed_of_week = st_of_week.end_of_week
        key = "#{st_of_week.strftime("%Y-%m-%d")}-#{ed_of_week.strftime("%Y-%m-%d")}"
        hash[key][object[1]] = count
      end
      hash
    end
  end

  private

  def set_default_workflow_state
    self.workflow_state ||= WORKFLOW_STATES.first
  end

end

