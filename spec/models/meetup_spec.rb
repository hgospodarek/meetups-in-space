require 'spec_helper'

RSpec.describe Meetup do
  it { should have_many :user_meetups}

  it { should have_valid(:name).when("Jupiter Jam", "A Fancy Meetup Name") }
  it { should_not have_valid(:name).when(nil, "") }

  it { should have_valid(:location).when("Jupiter", "Outer Space", "Secret Location on Earth") }
  it { should_not have_valid(:location).when(nil, "") }

  it { should have_valid(:description).when("Super cool super secret meetup", "Totally ok meetup description text.") }
  it { should_not have_valid(:description).when(nil, "") }

  # How to test for the fact that a Meetup must have a creator, but not necessarily attendees? Especially since "creator" is based on the join table?
end
