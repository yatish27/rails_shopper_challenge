FactoryGirl.define do
  factory :applicant do
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone }
    phone_type { Applicant::PHONE_TYPES.sample }
    region { Applicant::REGIONS.sample }
    workflow_state { Applicant::WORKFLOW_STATES.sample }
  end
end