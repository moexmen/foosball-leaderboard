class ScoresController < ApplicationController
  def index
    active_tab

    params[:sort_by] = 'wins' unless params[:sort_by]

    @sort_by = params[:sort_by].downcase
    @scores = case @sort_by
              when 'points'
                sort_by_points
              when 'win-ratio'
                sort_by_ratio
              when 'win-streak'
                sort_by_streak
              else
                sort_by_wins
              end
  end

  def sort_by_wins
    Score.includes(:player).sort_by { |s| [s.wins, s.points] }.reverse!
  end

  def sort_by_points
    Score.includes(:player).sort_by { |s| s.points }.reverse!
  end

  def sort_by_ratio
    Score.includes(:player).sort_by { |s| [s.wRatio, s.points] }.reverse!
  end

  def sort_by_streak
    Score.includes(:player).sort_by { |s| [s.win_streak, s.points] }.reverse!
  end

  def active_tab
    @active = 2
  end
end
