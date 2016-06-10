require 'spec_helper'

RSpec.describe UserMeetup do
  it { should belong_to :user }
  it { should belong_to :meetup }
end
