class Match < ActiveRecord::Base
  # For winners
  # 0 = red
  # 1 = blue

  before_create do
    self.winner = get_winner
    puts "[SERVER] New match is created at #{self.created_at}"
  end

  before_update do
      self.winner = get_winner
      puts "[SERVER] Match #{self.id} is edited at #{self.updated_at}"
  end

  def get_winner
    self.redGoal > self.blueGoal ? 0 : 1
  end

end
