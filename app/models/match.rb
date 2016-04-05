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
      remove_match_from_scoreboard
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

  before_destroy do
    remove_match_from_scoreboard

    # destroy match object and playerMatch objects
    player_matches_arr = PlayerMatch.where(:match_id => self.id)
    player_matches_arr.each { |player_match| player_match.destroy }
  end

  def remove_match_from_scoreboard
    # remove this match instance from scoreboard
    player_matches_arr = PlayerMatch.where(:match_id => self.id)
    player_matches_arr.each { |player_match| Score.remove_match(self.id, player_match) }
  end

  def get_winner
    self.redGoal > self.blueGoal ? 'r' : 'b'
  end

  def self.get_matches_json(player_id)
    # return json of matches
    matches = []
    single_pm_records = PlayerMatch.where(:player_id => player_id)
    single_pm_records.each do |pm|
      matches.push(Match.where(:id => pm.match_id).take!)
    end

    match_json_arr = []
    matches.each do |match|
      match_pm_records = PlayerMatch.where(:match_id => match.id)
      # puts match_pm_records

      # Setup json and append
      red_atk = Player.find((match_pm_records.where(:position => 'atk', :team => 'r').take!).player_id).name
      blue_atk = Player.find((match_pm_records.where(:position => 'atk', :team => 'b').take!).player_id).name
      red_def = Player.find((match_pm_records.where(:position => 'def', :team => 'r').take!).player_id).name
      blue_def = Player.find((match_pm_records.where(:position=> 'def', :team => 'b').take!).player_id).name

      json_hash = {
          :match_id => match.id,
          :red_atk => red_atk,
          :red_def => red_def,
          :red_goal => match.redGoal,
          :blue_atk => blue_atk,
          :blue_def => blue_def,
          :blue_goal => match.blueGoal,
          :winner => match.winner,
          :date => match.created_at.strftime('%d %^b %Y')
      }

      match_json_arr.push(json_hash)
    end

    puts JSON.pretty_generate(match_json_arr)
    return JSON.pretty_generate(match_json_arr)
  end

  def self.get_created_date 
    match.created_at.strftime('%d %^b %Y')
  end

end
