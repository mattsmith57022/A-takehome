require 'rails_helper'

RSpec.describe User, type: :model do
  let (:user) { User.create!(name: 'User 1', email: 'user1@user1.com') }

  describe 'relationships' do
    it 'has many votes' do
      expect(user.respond_to?(:votes)).to eq(true)
    end
    it 'has many candidates' do
      expect(user.respond_to?(:candidates)).to eq(true)
    end
    it 'has many polls' do
      expect(user.respond_to?(:polls)).to eq(true)
    end
  end

  describe 'scope#voted_in_multiple_polls' do
    it 'returns the users who have voted in 2 or more polls within the time range' do
      vote_setup
      users = User.voted_in_multiple_polls(1.day.ago.beginning_of_day, Time.current.end_of_day)
      expect(users.include?(user)).to eq(true)
    end
  end

  describe 'self#percent_voted_in_multiple_polls' do
    it 'returns the percent of users who have voted in multiple polls' do
      vote_setup
      User.create!(name: 'User 2', email: 'user2@user2.com')
      percent = User.percent_voted_in_multiple_polls(1.day.ago.beginning_of_day, Time.current.end_of_day)
      expect(percent).to eq(50.0)
    end
  end
end

def vote_setup
  poll = Poll.create!(name: 'Poll 1')
  candidate = Candidate.create!(name: 'Employee1', poll: poll)
  Vote.create!(candidate: candidate, user: user)
  poll = Poll.create!(name: 'Poll 2')
  candidate = Candidate.create!(name: 'Employee1', poll: poll)
  Vote.create!(candidate: candidate, user: user)
end
