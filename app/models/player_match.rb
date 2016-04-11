class PlayerMatch < ActiveRecord::Base
  belongs_to :match
  belongs_to :player
  after_create 'update_player_score'
  after_update 'update_player_score'

  def update_player_score
    Score.update_player_score(self.match_id, self)
  end
end
