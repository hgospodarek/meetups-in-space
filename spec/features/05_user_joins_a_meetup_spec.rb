require 'spec_helper'

feature 'users can join meetups' do

  let(:user) { FactoryGirl.create(:user) }


  scenario 'there is no Join Meetup button if user is already member' do
    current_meetup = FactoryGirl.create(:meetup)
    meetup_creator = FactoryGirl.create(:creator, meetup: current_meetup)


    visit '/meetups'
    sign_in_as user

    UserMeetup.create(user: user, meetup: current_meetup)

    click_link "#{current_meetup.name}"

    expect(page).not_to have_content('Join Meetup')

  end

  scenario 'a signed in user can join a meetup they are not already a member of' do
    current_meetup = FactoryGirl.create(:meetup)
    meetup_creator = FactoryGirl.create(:creator, meetup: current_meetup)

    visit '/meetups'

    sign_in_as user

    click_link "#{current_meetup.name}"

    click_button 'Join Meetup'

    expect(page).to have_content("You joined this meetup!")

  end

  scenario 'if user is not signed in, they cannot join a meetup' do
    current_meetup = FactoryGirl.create(:meetup)
    meetup_creator = FactoryGirl.create(:creator, meetup: current_meetup)

    visit '/meetups'

    click_link "#{current_meetup.name}"

    click_button 'Join Meetup'
    expect(page).to have_content("You cannot join a meetup until you sign in.")
  end

end
