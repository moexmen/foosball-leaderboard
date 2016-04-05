require 'json'

class MatchesController < ApplicationController
  def index
    active_tab
    @matches_details = JSON.parse(Match.get_all_matches_json)
    @matches = Match.all

    puts 'MATCHES.ALL'
    puts @matches[0].id
    # puts json_hash
    # puts @matches

  end

  def new
    @match = Match.new
  end

  def edit
    # called upon submitting GET request
    @match = Match.find(params[:id])
    @match_detail = Match.get_match_json(@match)
  end

  def create
    puts 'HELLO WE REACHED THE CREATE USING NEW FORM_TAGS YAY'

    puts 'PARAMS ARE WE THERE YET'

    @match = Match.new(redGoal: match_params[:redGoal], blueGoal: match_params[:blueGoal], winner: match_params[:winner])
    @match.add_matches(match_params[:redAtt], match_params[:redDef], match_params[:blueAtt], match_params[:blueDef])
    @match.save

    redirect_to matches_path

    # if @match.save
    #   # successful validations
    #   redirect_to matches_path
    # else
    #   render 'new'
    # end
  end

  def update
    # called upon submitting a PATCH request through edit
    @match = Match.find(params[:id])

    @match.add_matches(match_params[:redAtt], match_params[:redDef], match_params[:blueAtt], match_params[:blueDef])
    @match.update(redGoal: match_params[:redGoal], blueGoal: match_params[:blueGoal], winner: match_params[:winner])


    redirect_to matches_path

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

end
