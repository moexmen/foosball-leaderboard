class Match < ActiveRecord::Base
  has_many :player_matches
  has_many :players, through: :player_matches
  attr_accessor :red_att
  attr_accessor :red_def
  attr_accessor :blue_att
  attr_accessor :blue_def

  # TODO: Handle single player for team
  before_create do
    self.winner = get_winner
    puts "[SERVER] New match is created at #{self.created_at}"
  end

  after_create do
    # generate new records to player_match table
    player_team_hash = {
        :red => [self.red_att, self.red_def],
        :blue => [self.blue_att, self.blue_def]
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
        self.red_att, self.red_def, self.blue_att, self.blue_def
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

  def self.get_player_matches(player_id)
    # @return matches array for a single player
    matches = []
    single_pm_records = PlayerMatch.where(:player_id => player_id)
    single_pm_records.each do |pm|
      matches.push(Match.where(:id => pm.match_id).take!)
    end
    return get_matches_arr(matches)
  end

  def self.get_all_matches_arr
    return get_matches_arr(Match.all)
  end

  def add_players_for_match(red_att, red_def, blue_att, blue_def)
    self.red_att = red_att
    self.red_def = red_def
    self.blue_att = blue_att
    self.blue_def = blue_def
  end

  # helpers
  def self.get_matches_arr(matches)
    # @return matches array
    match_info_arr = []
    matches.each do |match|
      match_info_arr.push(get_match_hash(match))
    end
    return match_info_arr
  end

  def self.get_player_from_pm(players, pm)
    players.each do |player|
      if pm.player_id == player.id
        return player
      end
    end
  end

  def self.get_match_hash(match)
    # @return single match hash
    player_matches = match.player_matches
    players = match.players
    red_atk ||= []
    red_def ||= []
    blue_atk ||= []
    blue_def ||= []

    # find player with associated team and position
    player_matches.each do |pm|
      if pm.position == 'atk' and pm.team == 'r'
        red_atk = get_player_from_pm(players, pm)
      elsif pm.position == 'atk' and pm.team == 'b'
        blue_atk = get_player_from_pm(players, pm)
      elsif pm.position == 'def' and pm.team == 'r'
        red_def = get_player_from_pm(players, pm)
      else
        blue_def = get_player_from_pm(players, pm)
      end
    end
    
    match_hash = {
        match: match,
        red_atk: red_atk,
        red_def: red_def,
        blue_atk: blue_atk,
        blue_def: blue_def
    }
  end
end
