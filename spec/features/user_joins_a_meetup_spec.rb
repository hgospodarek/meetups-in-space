require 'spec_helper'

feature 'users can join meetups' do

  let(:user) do
    User.create(
    provider: "github",
    uid: "500",
    username: "jarlax1",
    email: "jarlax1@launchacademy.com",
    avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end


  scenario 'there is no Join Meetup button if user is already member' do
    meetup_list = FactoryGirl.create_list(:meetup, 12)
    current_meetup = FactoryGirl.create(:meetup, name: 'A Meetup Starting with A')

    visit '/meetups'
    sign_in_as user

    UserMeetup.create(user: user, meetup: current_meetup, creator: true)

    click_link 'A Meetup Starting with A'

    expect(page).not_to have_content('Join Meetup')

  end

  scenario 'a signed in user can join a meetup they are not already a member of' do
    meetup_list = FactoryGirl.create_list(:meetup, 12)
    current_meetup = FactoryGirl.create(:meetup, name: 'A Meetup Starting with A')
    meetup_creator = FactoryGirl.create(:user_meetup, meetup: current_meetup, creator: true)

    visit '/meetups'

    sign_in_as user

    click_link 'A Meetup Starting with A'

    click_button 'Join Meetup'

    expect(page).to have_content("You have joined a meetup.")

  end

  scenario 'if user is not signed in, they cannot join a meetup' do
    meetup_list = FactoryGirl.create_list(:meetup, 12)
    current_meetup = FactoryGirl.create(:meetup, name: 'A Meetup Starting with A')
    meetup_creator = FactoryGirl.create(:user_meetup, meetup: current_meetup, creator: true)

    visit '/meetups'

    click_link 'A Meetup Starting with A'

    click_button 'Join Meetup'
    expect(page).to have_content("You cannot join a meetup until you sign in.")
  end

end
