require 'json'

class MatchesController < ApplicationController
  def index
    active_tab
    @matches_details = JSON.parse(Match.get_all_matches_json)
    @matches = Match.all
  end

  def new
    @match = Match.new
  end

  def edit
    # called upon submitting GET request
    @match = Match.find(params[:id])
    @match_detail = JSON.parse(Match.get_match_json(@match))
  end

  def create
    @match = Match.new(redGoal: match_params[:redGoal], blueGoal: match_params[:blueGoal], winner: match_params[:winner])
    update_players_for_match
    if @match.save
      # successful validations
      redirect_to matches_path
    else
      render 'new'
    end
  end

  def update
    # called upon submitting a PATCH request through edit
    @match = Match.find(params[:id])
    update_players_for_match
    update_hash = {
        redGoal: match_params[:redGoal],
        blueGoal: match_params[:blueGoal],
        winner: match_params[:winner]
    }

    if @match.update(update_hash)
      redirect_to matches_path
    else
      render 'edit'
    end
  end

  def destroy
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

  private
  def update_players_for_match
    @match.add_players_for_match(match_params[:redAtt], match_params[:redDef], match_params[:blueAtt], match_params[:blueDef])
  end

end
