class ScoresController < ApplicationController
  def index
    @scores = sort_by_wins
    @players = Player.all
  end

  def sort_by_wins
    @scores = Score.all.sort { |s1, s2| s2.wins <=> s1.wins}
  end

end
