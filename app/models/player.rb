class Player < ActiveRecord::Base
  has_one :score, dependent: :destroy

  after_create do
    # generate score record
    # Score.create(wins: 0, loses: 0, points: 0, goals: 0, wRatio: 0, pullUps: 0, player_id: self.id)
    puts "[SERVER] Generated new score record for player #{self.id}"
  end

  def self.get_profile_json(player_id)
    match_arr_json = Match.get_player_matches_json(player_id)
    score_json = Score.get_score_json(player_id)

    profile_json = {
        :score_details => score_json,
        :match_details => match_arr_json
    }

    full_json = JSON.pretty_generate(profile_json)
    return full_json
  end

end
