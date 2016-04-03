class Player < ActiveRecord::Base
  has_one :Score, dependent: :destroy

  after_create do
    # generate score record
    Score.create(wins: 0, loses: 0, points: 0, goals: 0, wRatio: 0, pullUps: 0, player_id: self.id)
    puts "[SERVER] Generated new score record for player #{self.id}"
  end


end
