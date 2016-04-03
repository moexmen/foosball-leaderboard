class Match < ActiveRecord::Base

  before_create do
    self.winner = get_winner
    puts "[SERVER] New match is created at #{self.created_at}"
  end

  after_create do
    # TODO: generate new records to player_match table
    player_team_hash = {
        :red => [redAtt, redDef],
        :blue => [blueAtt, blueDef]
    }

    player_team_hash.each do |key, player_team|
      player_team.each do |item|
        # generate record for player_match
        PlayerMatch.create(match_id: id, player_id: item, team:key )
      end
    end


  end

  before_update do
      self.winner = get_winner
      puts "[SERVER] Match #{self.id} is edited at #{self.updated_at}"
  end


  def get_winner
    self.redGoal > self.blueGoal ? 0 : 1
  end

end
