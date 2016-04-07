class MatchesController < ApplicationController
  include ActiveModel::Validations

  validate do
    errors.add(:base, 'Blue team cannot win')
  end

  def index
    active_tab
    @matches = Match.all
  end

  def new
    active_tab
    @match = Match.new
    @players = Player.where(active: true)
  end

  def edit
    # called upon submitting GET request
    active_tab
    @match = Match.find(params[:id])
    @players = Player.where(active: true)
  end

  def create
    @errors = validation
    puts 'LOOK HERE GUYS'
    puts @errors

    if @errors.empty?
      update_players_for_match
      @match = Match.create(redGoal: match_params[:redGoal], blueGoal: match_params[:blueGoal], winner: match_params[:winner])
      redirect_to matches_path
    else
      @errors
      redirect_to new_match_path
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

  private
  def update_players_for_match
    @match.add_players_for_match(match_params[:redAtt], match_params[:redDef], match_params[:blueAtt], match_params[:blueDef])
  end

  private
  def validation
    players = [match_params[:redAtt], match_params[:redDef], match_params[:blueAtt], match_params[:blueDef]]
    error = {}
    error[:goal] = 'Invalid goals' if not check_goal(match_params[:redGoal], match_params[:blueGoal])
    error[:player] = 'Duplicate players' if not check_players (players)
    return error
  end

  private
  def check_goal (goal1, goal2)
     if goal1 == 10
       goal2 == 10 ? false : true
     end

     if goal2 == 10
       goal1 == 10 ? false : true
     end
  end

  private
  def check_players (players)
    players.each_with_index do |p|
      other_players = players.clone
      other_players.delete_at(players.index(p))
      other_players.each {|op| return false if op == p}
      true
    end
  end

end
