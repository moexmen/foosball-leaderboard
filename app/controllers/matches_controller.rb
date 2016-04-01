class MatchesController < ApplicationController
  def index
    @matches = Match.all
  end

  def new
    @match = Match.new
  end

  def edit
    # called upon submitting GET request
    @match = Match.find(params[:id])
  end

  def create
    @match = Match.new(match_params)

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

    if @match.update(match_params)
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

  private
  def match_params
    params.require(:match).permit(:redAtt, :redDef, :blueAtt, :blueDef, :redGoal, :blueGoal, )
  end

end
