require 'rails_helper'

RSpec.describe Poll, type: :model do
  let (:poll1) { Poll.create!(name:'Employee of the Year') }

  describe 'relationships' do
    it 'has many candidates' do
      expect(poll1.respond_to?(:candidates)).to eq(true)
    end
    it 'has many votes' do
      expect(poll1.respond_to?(:votes)).to eq(true)
    end
  end

  describe '#results' do
    it 'gets all votes grouped by Candidates name' do
      user =  User.create!(name: 'The Employee1', email: 'employee1@oftheyear.com')
      candidate = Candidate.create!(name: 'Employee1', poll: poll1)
      Vote.create!(candidate: candidate, user: user)
      Candidate.create!(name: 'Employee2', poll: poll1)

      poll2 = Poll.create!(name:'Employee of the Month')
      candidate = Candidate.create!(name: 'Employee1', poll: poll2)
      Vote.create!(candidate: candidate, user: user)

      poll1_expected_results = {
        'Employee1' => 1,
        'Employee2' => 0
      }
      expect(poll1.results).to eq(poll1_expected_results)
    end
  end
end
