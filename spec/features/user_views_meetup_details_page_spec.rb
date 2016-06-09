require 'spec_helper'

feature 'user views list of meetups' do

  scenario 'user can get to meetup details page through meetups index page' do
    meetup_list = FactoryGirl.create_list(:meetup, 12)
    current_meetup = FactoryGirl.create(:meetup, name: 'A Meetup Starting with A')
    meetup_creator = FactoryGirl.create(:user_meetup, meetup: current_meetup, creator: true)

    visit '/meetups'
    click_link 'A Meetup Starting with A'
    expect(page).to have_current_path("/meetups/#{current_meetup.id}")
  end

  scenario 'user views meetup details' do
    meetup_list = FactoryGirl.create_list(:meetup, 12)
    current_meetup = FactoryGirl.create(:meetup, name: 'A Meetup Starting with A')
    meetup_creator = FactoryGirl.create(:user_meetup, meetup: current_meetup, creator: true)


    visit '/meetups'
    click_link 'A Meetup Starting with A'

    expect(page).to have_content('A Meetup Starting with A')
    expect(page).to have_content('Saturn')
    expect(page).to have_content('A super wicked cool meetup in outer space')
    expect(page).to have_content(current_meetup.creator.username)

  end

  scenario 'user can see attendees list' do
    meetup_list = FactoryGirl.create_list(:meetup, 12)
    current_meetup = FactoryGirl.create(:meetup, name: 'A Meetup Starting with A')
    attendees_list = FactoryGirl.create_list(:user_meetup, 5, meetup: current_meetup)
    meetup_creator = FactoryGirl.create(:user_meetup, meetup: current_meetup, creator: true)



    visit '/meetups'
    click_link 'A Meetup Starting with A'

    current_meetup.attendees.each do |attendee|
      expect(page).to have_content(attendee.username)
      expect(page).to have_css("img[src*='https://avatars2.githubusercontent.com/u/174825?v=3&s=400']")
    end

  end

end
