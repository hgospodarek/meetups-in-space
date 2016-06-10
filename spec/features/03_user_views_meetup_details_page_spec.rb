require 'spec_helper'

feature 'user views list of meetups' do

  scenario 'user can get to meetup details page through meetups index page' do
    current_meetup = FactoryGirl.create(:meetup)
    meetup_creator = FactoryGirl.create(:creator, meetup: current_meetup)

    visit '/meetups'
    click_link "#{current_meetup.name}"
    expect(page).to have_current_path("/meetups/#{current_meetup.id}")
  end

  scenario 'user views meetup details' do
    current_meetup = FactoryGirl.create(:meetup)
    meetup_creator = FactoryGirl.create(:creator, meetup: current_meetup)


    visit '/meetups'
    click_link "#{current_meetup.name}"

    expect(page).to have_content(current_meetup.name)
    expect(page).to have_content(current_meetup.location)
    expect(page).to have_content(current_meetup.description)
    expect(page).to have_content(current_meetup.creator.username)

  end

  scenario 'user can see attendees list' do
    current_meetup = FactoryGirl.create(:meetup)
    attendees_list = FactoryGirl.create_list(:user_meetup, 5, meetup: current_meetup)
    meetup_creator = FactoryGirl.create(:creator, meetup: current_meetup)

    visit '/meetups'
    click_link "#{current_meetup.name}"

    current_meetup.attendees.each do |attendee|
      expect(page).to have_content(attendee.username)
      expect(page).to have_css("img[src*='https://avatars2.githubusercontent.com/u/174825?v=3&s=400']")
    end
  end

end
