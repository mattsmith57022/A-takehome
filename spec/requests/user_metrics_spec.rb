require 'rails_helper'

RSpec.describe '/user_metrics', type: :request do

  describe 'GET /percent_voted_in_multiple_polls' do
    it 'returns the percent of users who have voted in multiple polls' do
      user = User.create!(name: 'User 1', email: 'user1@user1.com')
      poll = Poll.create!(name: 'Poll 1')
      candidate = Candidate.create!(name: 'Employee1', poll: poll)
      Vote.create!(candidate: candidate, user: user)
      poll = Poll.create!(name: 'Poll 2')
      candidate = Candidate.create!(name: 'Employee1', poll: poll)
      Vote.create!(candidate: candidate, user: user)
      User.create!(name: 'User 2', email: 'user2@user2.com')


      start_date = Time.current.beginning_of_day.to_date.to_s
      end_date = Time.current.to_date.to_s
      get user_metrics_percent_voted_in_multiple_polls_path, params: { start_date: start_date, end_date: end_date }
      expect(response.status).to eq(200)
      response_json = JSON.parse(response.body)
      expect(response_json['data']).to eq(50.0)
    end
  end
  it 'requires start_time and end_time' do
    get user_metrics_percent_voted_in_multiple_polls_path
    expect(response.status).to eq(400)
  end
end
