class Match < ActiveRecord::Base
  # TODO: Handle single player for team
  before_create do
    self.winner = get_winner
    puts "[SERVER] New match is created at #{self.created_at}"
  end

  after_create do
    # generate new records to player_match table
    player_team_hash = {
        :red => [self.redAtt, self.redDef],
        :blue => [self.blueAtt, self.blueDef]
    }

    player_team_hash.each do |key, player_team|
      player_team.each_with_index do |item, index|
        # generate record for player_match
        player_pos = (index == 0) ? 'atk' : 'def'
        PlayerMatch.create(match_id: self.id, player_id: item, team:key[0], position: player_pos)
      end
    end
  end

  before_update do
      self.winner = get_winner

      # remove old match record
      player_matches_arr = PlayerMatch.where(:match_id => self.id)
      player_matches_arr.each { |player_match| Score.remove_match(self.id, player_match) }
  end

  after_update do
    # update playerMatch records
    player_hash = [
        self.redAtt, self.redDef, self.blueAtt, self.blueDef
    ]

    update_pm_arr = PlayerMatch.where(:match_id => self.id)
    update_pm_arr.each_with_index do |pm, index|
      pm.update(match_id: self.id, player_id: player_hash[index], team:pm.team, position: pm.position)
    end

    puts "[SERVER] Match #{self.id} is edited at #{self.updated_at}"
  end

  def get_winner
    self.redGoal > self.blueGoal ? 'r' : 'b'
  end

end
