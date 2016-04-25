module MatchValidation
  def validate(match_params)
    error = {}
    @goal_check = false
    @player_check = false
    @blanks = []

    params_list = %w[redAtt redDef blueAtt blueDef redGoal blueGoal]
    params_list.each { |p| check_selected(match_params[p]) }

    if @blanks.count(true) == 6
      check_goal(match_params[:redGoal].to_i, match_params[:blueGoal].to_i)
      check_players([match_params[:redAtt], match_params[:redDef], match_params[:blueAtt], match_params[:blueDef]])
      error[:goal] = false if @goal_check
      error[:player] = false if @player_check
    end

    error[:blanks] = @blanks if @blanks.count(true) < 6
    error
  end

  def check_selected(field)
    field.present? ? @blanks.push(true) : @blanks.push(false)
  end

  def check_goal(goal1, goal2)
    @goal_check = true if goal1 == 10 && goal2 == 10
    @goal_check = true if goal1 < 10 && goal2 < 10

    @goal_check = true if goal1 == 'Score' || goal2 == 'Score'
  end

  def check_players(players)
    players.each_with_index do |p|
      other_players = players.clone
      other_players.delete_at(players.index(p))
      @player_check = other_players.include?(p)
      break if @player_check
    end
  end
end
