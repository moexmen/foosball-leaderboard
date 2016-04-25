class Score < ActiveRecord::Base
  belongs_to :player
  before_create :set_defaults if :new_record?

  def self.remove_match(match_id, player_match)
    match = Match.find(match_id)

    if Score.exists?(player_id: player_match.player_id)
      score = Score.where(player_id: player_match.player_id).take!

      # remove wins, loses, points and update streak
      (match.winner == player_match.team) ? score.wins -= 1 : score.loses -= 1
      (match.winner == player_match.team) ? score.points -= 3 : score.points -= 1

      # remove goals
      (player_match.team == 'r') ? score.goals -= match.redGoal : score.goals -= match.blueGoal

      # remove pullUps
      no_pull_up = (match.winner == 'r') ? match.redGoal - match.blueGoal : match.blueGoal - match.redGoal
      score.pullUps -= no_pull_up if match.winner != player_match.team

      # update wRatio
      new_win_ratio = score.wins.fdiv(score.wins + score.loses)
      score.wRatio = sprintf('%.10f', new_win_ratio)

      score.save
      puts "[SERVER] Removed match #{match.id} from player #{player_match.player_id}'s scoreboard"
    end
  end

  def self.update_player_score(match_id, player_match)
    match = Match.find(match_id)

    if Score.exists?(player_id: player_match.player_id)
      score = Score.where(player_id: player_match.player_id).take!

      # update wins, loses, points and streaks
      (match.winner == player_match.team) ? score.wins += 1 : score.loses += 1
      (match.winner == player_match.team) ? score.points += 3 : score.points += 1

      # update goals
      (player_match.team == 'r') ? score.goals += match.redGoal : score.goals += match.blueGoal

      # update pullUps
      no_pull_up = (match.winner == 'r') ? match.redGoal - match.blueGoal : match.blueGoal - match.redGoal
      score.pullUps += no_pull_up if match.winner != player_match.team

      # update wRatio
      new_win_ratio = score.wins.fdiv(score.wins + score.loses)
      score.wRatio = sprintf('%.10f', new_win_ratio)

      # save scoreboard
      score.save
      puts "[SERVER] Updated scoreboard of player #{player_match.player_id}"
    end
  end

  def self.update_win_streak
    Score.all.each do |score|
      score.win_streak = compute_win_streak(score.player.id)
      score.save
    end

    update_longest_ws
  end

  def self.update_longest_ws
    Score.all.each do |score|
      if score.win_streak > score.longest_win_streak
        score.longest_win_streak = score.win_streak
        score.save
      end
    end
  end

  def self.compute_win_streak(player_id)
    p_matches = Player.find(player_id).player_matches
    win_streak = 0

    p_matches.each do |p_match|
      if p_match.team == p_match.match.winner
        win_streak >= 0 ? win_streak += 1 : win_streak = 1
      else
        win_streak <= 0 ? win_streak -= 1 : win_streak = -1
      end
    end

    win_streak
  end

  private

  def set_defaults
    self.wins ||= 0
    self.loses ||= 0
    self.points ||= 0
    self.goals ||= 0
    self.wRatio ||= 0
    self.pullUps ||= 0
    self.win_streak ||= 0
    self.longest_win_streak ||= 0
  end
end
