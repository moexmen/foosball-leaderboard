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
    @goal_check = true
    @player_check = false

    check_players([match_params[:redAtt], match_params[:redDef], match_params[:blueAtt], match_params[:blueDef]])
    check_goal(match_params[:redGoal].to_i, match_params[:blueGoal].to_i)

    error = {}
    error[:goal] = false if @goal_check
    error[:player] = false if @player_check
    error
  end

  def check_goal (goal1, goal2)
    @goal_check = false if goal1 == 10 && goal2 < 10
    @goal_check = false if goal2 == 10 && goal1 < 10
  end

  def check_players (players)
    players.each_with_index do |p|
      other_players = players.clone
      other_players.delete_at(players.index(p))
      other_players.each { |op| @player_check = true if op == p}
    end
  end

  def check_for_error_params
    error = {}
    error[:goal] = 'Goals is invalid' if params.key?('goal')
    error[:player] = 'Player is invalid' if params.key?('player')
    error
  end
end
