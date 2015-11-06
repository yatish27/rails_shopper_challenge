require 'rails_helper'

feature 'Applicant' do
  scenario '2 step applicant creation' do
    visit root_path
    within(:css, "div.intro") do
      click_link('Apply Now')
    end
    
    elem = find(:css, '#applicant_first_name')
    fill_in elem[:name], with: Faker::Name.name

    elem = find(:css, '#applicant_last_name')
    fill_in elem[:name], with: Faker::Name.name

    elem = find(:css, '#applicant_email')
    fill_in elem[:name], with: Faker::Internet.email

    elem = find(:css, '#applicant_phone')
    fill_in elem[:name], with: Faker::PhoneNumber.cell_phone

    select('NYC', from: 'applicant[region]')
    select('Other', from: 'applicant[phone_type]')

    click_button('Submit')

    expect(page).to have_text("I hereby authorize Instacart to investigate my background")
    click_button('Submit')

    expect(page).to have_text("Application Confirmed")
  end
end