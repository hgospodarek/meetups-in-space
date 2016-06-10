require 'spec_helper'

feature 'user creates new meetup' do

  scenario 'user cannot create new meetup if not signed in' do
    visit '/meetups'
    click_button 'Create Meetup'
    expect(page).to have_content('You cannot create a meetup without signing in.')
  end

  let(:user) { FactoryGirl.create(:user) }

  scenario 'user can get to new meetup form through meetups index page if signed in' do
    visit '/'
    sign_in_as user
    click_button 'Create Meetup'

    expect(page).to have_current_path('/meetups/new')
    expect(page).to have_content('Name:')
    expect(page).to have_content('Location:')
    expect(page).to have_content('Description:')
  end

  scenario 'user successfully adds a meetup' do

    visit '/'
    sign_in_as user
    click_button'Create Meetup'

    fill_in("name", :with => "This Meetup Has a Long Name")
    fill_in("location", :with => "Saturn")
    fill_in("description", :with => "Partying on Saturn")
    click_button "Submit"

    expect(page).to have_content('Meetup created successfully!')
    expect(page).to have_content('This Meetup Has a Long Name')
  end

  scenario 'meetup will not be created if form incomplete' do
    visit '/'
    sign_in_as user
    click_button 'Create Meetup'

    click_button "Submit"

    expect(page).to have_current_path('/meetups/new')
    expect(page).to have_content('Please fill out form completely.')
  end
end
