class MatchesController < ApplicationController
  def index
    @matches = Match.all
  end

  def new
    @match = Match.new
  end

  def create
    # For winners
    # 0 = red
    # 1 = blue

    game_winner = decide_winner(match_params[:redGoal], match_params[:blueGoal])
    @match = Match.new(:redAtt => match_params[:redAtt], :redDef => match_params[:redDef], :redGoal => match_params[:redGoal],
                       :blueAtt => match_params[:blueAtt], :blueDef => match_params[:blueDef], :blueGoal => match_params[:blueGoal],
                       :winner => game_winner)

    if @match.save
      # successful validations
      redirect_to matches_path
    else
      render 'new'
    end
  end

  private
  def decide_winner(red_goal, blue_goal)
    red_goal > blue_goal ? 0 : 1
  end

  private
  def match_params
    params.require(:match).permit(:redAtt, :redDef, :blueAtt, :blueDef, :redGoal, :blueGoal, )
  end

end
