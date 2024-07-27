class Poll < ApplicationRecord
    validates_presence_of :name
    has_many :candidates
    has_many :votes, through: :candidates

    # Assumes Candidates names are unique within a given poll
    def results
        candidates.left_joins(:votes).group(:name).count('votes.id')
    end
end
