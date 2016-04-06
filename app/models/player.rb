class Player < ActiveRecord::Base
  has_one :score, dependent: :destroy
  has_many :matches, through: :player_matches

  after_create do
    # generate score record
    Score.create(wins: 0, loses: 0, points: 0, goals: 0, wRatio: 0, pullUps: 0, player_id: self.id)
    puts "[SERVER] Generated new score record for player #{self.id}"
  end

  def self.get_profile_info(player_id)
    match_arr = Match.get_player_matches(player_id)
    score_info = Score.get_score_info(player_id)

    profile_info = {
        :player => Player.find(player_id),
        :score => score_info,
        :match_details => match_arr
    }

    return profile_info
  end

  def self.inactive(player)
    player.active = false
    player.save
    player.score.destroy
  end

end
