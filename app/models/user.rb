class User < ApplicationRecord
    validates_presence_of :name
    validates_presence_of :email
    has_many :votes
    has_many :candidates, through: :votes
    has_many :polls, through: :candidates

    scope :voted_in_multiple_polls, -> (start_time, end_time) {
        time_range = start_time..end_time
        joins(votes: { candidate: :poll })
        .where(votes: { created_at: time_range })
        .group('users.id')
        .having('count(distinct(polls.id)) >= 2')
      }

    def self.percent_voted_in_multiple_polls(start_time, end_time)
        user_vote_counts = voted_in_multiple_polls(start_time, end_time).count
        num_users = user_vote_counts.length
        ratio = num_users.fdiv(count)
        percent = ratio * 100
        percent.round(2)
    end
end
