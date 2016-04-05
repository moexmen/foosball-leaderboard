class MatchesController < ApplicationController
  def index
    active_tab
    @matches = Match.all
  end

  def new
    active_tab
    @match = Match.new
  end

  def edit
    # called upon submitting GET request
    active_tab
    @match = Match.find(params[:id])
  end

  def create
    @match = Match.new(match_params)
    # @match.get_additional_params(match_additional_params)
    @time = []
    @match.each do |match|
      @time.push(match.get_created_date)
      puts match.get_created_date
    end

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
    params.require(:match).permit(:redAtt, :blueAtt, :redDef, :blueDef, :redGoal, :blueGoal,)
  end

  # private
  # def match_additional_params
  #   params.require(:match).permit(:redAtt, :blueAtt, :redDef, :blueDef,)
  # end

end
