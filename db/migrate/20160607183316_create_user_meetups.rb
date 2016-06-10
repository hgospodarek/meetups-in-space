class CreateUserMeetups < ActiveRecord::Migration
  def change
    create_table :user_meetups do |t|
      t.belongs_to :user, null: false
      t.belongs_to :meetup, null: false
      t.boolean :creator, null: false, default: false
    end
  end
end
