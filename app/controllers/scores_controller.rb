class ScoresController < ApplicationController
  def index
    active_tab

    params[:sort_by] = 'wins' unless params[:sort_by]

    @sort_by = params[:sort_by].downcase

    case @sort_by
      when 'points'
        @scores = sort_by_points
      when 'goals'
        @scores = sort_by_goals
      when 'pull-ups'
        @scores = sort_by_pull_ups
      else
        @scores = sort_by_wins
    end

  end

  def sort_by_wins
    Score.includes(:player).sort { |s1, s2| s2.wins <=> s1.wins}
  end

  def sort_by_points
    Score.includes(:player).sort { |s1, s2| s2.points <=> s1.points}
  end

  def sort_by_goals
    Score.includes(:player).sort { |s1, s2| s2.goals <=> s1.goals}
  end

  def sort_by_pull_ups
    Score.includes(:player).sort { |s1, s2| s2.pullUps <=> s1.pullUps}
  end

  def active_tab
    @active = 2
  end

end
