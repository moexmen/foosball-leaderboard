class MatchesController < ApplicationController
  include MatchValidation
  def index
    active_tab
    @matches = Match.all
  end

  def new
    active_tab
    @match = Match.new
    @players = Player.where(active: true).sort_by { |p| p.name }
    @error = check_for_error_params
  end

  def edit
    active_tab
    @match = Match.find(params[:id])
    @players = Player.where(active: true).sort_by { |p| p.name }
    @error = check_for_error_params
  end

  def create
    @match = Match.new(redGoal: match_params[:redGoal], blueGoal: match_params[:blueGoal], winner: match_params[:winner])

    if validate(match_params).empty?
      update_players_for_match
      @match.save
      redirect_to matches_path
    else
      redirect_to new_match_path(validate(match_params))
    end
  end

  def update
    @match = Match.find(params[:id])

    if validate(match_params).empty?
      update_hash = {
        redGoal: match_params[:redGoal],
        blueGoal: match_params[:blueGoal],
        winner: match_params[:winner]
      }
      update_players_for_match
      @match.update(update_hash)
      redirect_to matches_path
    else
      redirect_to action: :edit, id: @match.id, params: validate(match_params)
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
    params.permit(:redAtt, :redDef, :blueAtt, :blueDef, :redGoal, :blueGoal)
  end

  def update_players_for_match
    @match.add_players_for_match(match_params[:redAtt], match_params[:redDef], match_params[:blueAtt], match_params[:blueDef])
  end

  def check_for_error_params
    error = {}
    error[:goal] = 'A team must have 10 goals' if params.key?('goal')
    error[:player] = 'Duplicate players not allowed' if params.key?('player')
    error[:blanks] = params[:blanks] if params.key?('blanks')
    error
  end
end
