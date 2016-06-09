require 'spec_helper'

feature 'user creates new meetup' do

  scenario 'user cannot create new meetup if not signed in' do
    visit '/meetups'
    expect(page).to have_content('Please sign in to create new meetup.')
  end

  let(:user) do
    User.create(
    provider: "github",
    uid: "1",
    username: "jarlax1",
    email: "jarlax1@launchacademy.com",
    avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  scenario 'user can get to new meetup form through meetups index page if signed in' do
    visit '/'
    sign_in_as user
    click_link 'Create Meetup'

    expect(page).to have_current_path('/meetups/new')
    expect(page).to have_content('Name:')
    expect(page).to have_content('Location:')
    expect(page).to have_content('Description:')
  end

  scenario 'user successfully adds a meetup' do

    visit '/'
    sign_in_as user
    click_link 'Create Meetup'

    fill_in("name", :with => "This Meetup Has a Long Name")
    fill_in("location", :with => "Saturn")
    fill_in("description", :with => "Partying on Saturn")
    click_button "Submit"

    expect(page).to have_content('You created this Meetup!')
    expect(page).to have_content('This Meetup Has a Long Name')
  end

  scenario 'meetup will not be created if form incomplete' do
    visit '/'
    sign_in_as user
    click_link 'Create Meetup'

    click_button "Submit"

    expect(page).to have_current_path('/meetups/new')
    expect(page).to have_content('Please fill out form completely.')
  end
end
