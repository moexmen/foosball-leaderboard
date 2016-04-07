class Player < ActiveRecord::Base
  has_one :score, dependent: :destroy
  has_many :matches, through: :player_matches
  has_many :player_matches
  validates :name, presence: { message: "Required" }
  validates :alias, presence: { message: "Required" }

  after_create do
    # generate score record
    Score.create(wins: 0, loses: 0, points: 0, goals: 0, wRatio: 0, pullUps: 0, player_id: self.id)
    puts "[SERVER] Generated new score record for player #{self.id}"
  end

  def self.inactive(player)
    player.active = false
    player.save
    player.score.destroy
  end

end
