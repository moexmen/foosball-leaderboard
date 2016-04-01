class Match < ActiveRecord::Base
  # For winners
  # 0 = red
  # 1 = blue

  before_create do
    self.winner = get_winner
    puts "[SERVER] New match is created at #{self.created_at}"
  end

  after_create do
    red_att_score = Score.where(player_id: redAtt).take!
    red_def_score = Score.where(player_id: redDef).take!
    blue_att_score = Score.where(player_id: blueAtt).take!
    blue_def_score = Score.where(player_id: blueDef).take!
    red_score_list = [red_att_score, red_def_score]
    blue_score_list = [blue_att_score, blue_def_score]

    # update wins and loses
    if self.winner == 0
      red_score_list.each { |score| score.wins += 1 }
      blue_score_list.each { |score| score.loses += 1}
    else
      red_score_list.each { |score| score.loses += 1 }
      blue_score_list.each { |score| score.wins += 1}
    end

    # update goals
    red_score_list.each { |score| score.goals += self.redGoal }
    blue_score_list.each { |score| score.goals += self.blueGoal }

    red_score_list.each { |score| score.save }
    blue_score_list.each { |score| score.save }
    puts "[SERVER] Updated scoreboards for #{self.id}"
  end

  before_update do
      self.winner = get_winner
      puts "[SERVER] Match #{self.id} is edited at #{self.updated_at}"
  end


  def get_winner
    self.redGoal > self.blueGoal ? 0 : 1
  end

end
