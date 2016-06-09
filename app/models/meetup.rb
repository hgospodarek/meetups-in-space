class Meetup < ActiveRecord::Base

  has_many :user_meetups
  has_many :users, through: :user_meetups

  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true

  def attendees
    attendees = user_meetups.where(creator: false)
    attendees.map { |a| a.user}
  end

  def creator
    user_meetups.find_by(creator: true).user
  end

end
