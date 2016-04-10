class MatchesController < ApplicationController
  def index
    active_tab
    @matches = Match.all
  end

  def new
    active_tab
    @match = Match.new
    @players = Player.where(active: true)
    @error = check_for_error_params
  end

  def edit
    active_tab
    @match = Match.find(params[:id])
    @players = Player.where(active: true)
    @error = check_for_error_params
  end

  def create
    @match = Match.new(redGoal: match_params[:redGoal], blueGoal: match_params[:blueGoal], winner: match_params[:winner])

    if validation.empty?
      update_players_for_match
      @match.save
      redirect_to matches_path
    else
      redirect_to new_match_path(validation)
    end
  end

  def update
    @match = Match.find(params[:id])

    if validation.empty?
      update_hash = {
          redGoal: match_params[:redGoal],
          blueGoal: match_params[:blueGoal],
          winner: match_params[:winner]
      }
      update_players_for_match
      @match.update(update_hash)
      redirect_to matches_path
    else
      redirect_to action: :edit, id: @match.id, params: validation
    end
  end

  def destroy
    active_tab
    @match = Match.find(params[:id])
    @match.destroy

    redirect_to matches_path
  end

  def active_tab
    @active = 3
  end

  private
  def match_params
    params.permit(:redAtt, :redDef, :blueAtt, :blueDef, :redGoal, :blueGoal, )
  end

  def update_players_for_match
    @match.add_players_for_match(match_params[:redAtt], match_params[:redDef], match_params[:blueAtt], match_params[:blueDef])
  end

  def validation
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

  def check_selected (field)
    field.present? ? @blanks.push(true) : @blanks.push(false)
  end

  def check_goal (goal1, goal2)
    @goal_check = true if goal1 == 10 && goal2 == 10
    @goal_check = true if goal1 < 10 && goal2 < 10

    if goal1 == 'Score'|| goal2 == 'Score'
      @goal_check = true
    end
  end

  def check_players (players)
    players.each_with_index do |p|
      other_players = players.clone
      other_players.delete_at(players.index(p))
      @player_check = other_players.include?(p)
      break if @player_check
    end
  end

  def check_for_error_params
    error = {}
    error[:goal] = 'A team must have 10 goals' if params.key?('goal')
    error[:player] = 'Duplicate players not allowed' if params.key?('player')
    error[:blanks] = params[:blanks] if params.key?('blanks')
    error
  end
end
