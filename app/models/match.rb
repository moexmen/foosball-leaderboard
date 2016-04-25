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

    Score.update_win_streak
  end

  before_update do
    self.winner = get_winner
    remove_match_from_score
  end

  after_update do
    # update playerMatch records
    player_hash = [
        self.red_att, self.red_def, self.blue_att, self.blue_def
    ]

    self.player_matches.each_with_index do |pm, index|
      pm.update(match_id: self.id, player_id: player_hash[index], team:pm.team, position: pm.position)
    end

    # Update win streaks
    Score.update_win_streak

    puts "[SERVER] Match #{self.id} is edited at #{self.updated_at}"
  end

  before_destroy do
    remove_match_from_score
    self.player_matches.each { |pm| pm.destroy }
  end

  after_destroy do
    Score.update_win_streak
  end

  def remove_match_from_score
    self.player_matches.each { |player_match| Score.remove_match(self.id, player_match) }
  end

  def get_winner
    self.redGoal > self.blueGoal ? 'r' : 'b'
  end

  def add_players_for_match(red_att, red_def, blue_att, blue_def)
    self.red_att = red_att
    self.red_def = red_def
    self.blue_att = blue_att
    self.blue_def = blue_def
  end

end
