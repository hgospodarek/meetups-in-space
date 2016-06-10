require 'spec_helper'

feature 'user views list of meetups' do

  scenario 'view list of meetups' do
    meetup_list = FactoryGirl.create_list(:meetup, 12)

    visit '/meetups'

    meetup_list.each do |meetup|
      expect(page).to have_content(meetup.name)
      expect(page).to have_content(meetup.description)
      expect(page).to have_content(meetup.location)
    end
  end

  scenario 'meetups are in alphabetical order' do
    meetup_list = FactoryGirl.create_list(:meetup, 12)
    meetup_list << FactoryGirl.create(:meetup, name: 'A Meetup Starting with A')

    visit '/meetups'

    first_meetup_postion = page.body.index('A Meetup Starting with A')
    other_meetup_position = page.body.index('Super Cool Meetup')
    expect(first_meetup_postion).to be < other_meetup_position
  end
end
