require 'rails_helper'

RSpec.describe Candidate, type: :model do
  let (:poll) { Poll.create(name:'Employee of the Year') }
  let (:candidate) { Candidate.create(name:'Employee1', poll: poll) }

  describe 'relationships' do
    it 'has many votes' do
      expect(candidate.respond_to?(:votes)).to eq(true)
    end
  end
end
