class ScoresController < ApplicationController
  def index
    active_tab
    # @scores = sort_by_wins
    @scores = Score.all
    @players = Player.all
  end

  def sort_by_wins
    @scores = Score.all.sort { |s1, s2| s2.wins <=> s1.wins}
  end 

  def active_tab
    @active = 2
  end

end
