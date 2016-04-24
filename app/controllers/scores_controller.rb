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
      when 'win-ratio'
        @scores = sort_by_win_ratio
      else
        @scores = sort_by_wins
    end

  end

  def sort_by_wins
    Score.includes(:player).sort_by { |s| [s.wins, s.points] }.reverse!
  end

  def sort_by_points
    Score.includes(:player).sort_by { |s| s.points }.reverse!
  end

  def sort_by_goals
    Score.includes(:player).sort_by { |s| [s.goals, s.points] }.reverse!
  end

  def sort_by_pull_ups
    Score.includes(:player).sort_by { |s| [s.pullUps, s.points] }.reverse!
  end

  def sort_by_win_ratio
    Score.includes(:player).sort_by { |s| [s.wRatio, s.points]}.reverse!
  end

  def active_tab
    @active = 2
  end

end
