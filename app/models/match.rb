class Match < ActiveRecord::Base
  before_create do
    self.winner = self.redGoal > self.blueGoal ? 0 : 1
    puts "[SERVER] New match is created at #{self.created_at}"
  end
end
