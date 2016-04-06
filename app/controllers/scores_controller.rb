class ScoresController < ApplicationController
  def index
    active_tab
    @players = Player.where(:active => true)

    if session[:sort_tab] == 1
      @scores = sort_by_points
    elsif session[:sort_tab] == 2
      @scores = sort_by_goals
    elsif session[:sort_tab] == 3
      @scores = sort_by_pull_ups
    else
      @scores = sort_by_points
    end

    @html_option_string = ''
    options = %w(Wins Points Goals Pull-ups)
    options.each_with_index do |item, index|
      if index == session[:sort_tab]
        # Previous selected option
        @html_option_string << "<option value= \"#{item}\" selected>#{item}</option>"
      else
        # Other selected option
        @html_option_string << "<option value= \"#{item}\">#{item}</option>"
      end
    end
  end

  def update_score
    @scores = sort_by_points

    case params[:score_sort]
      when 'Points'
        @scores = sort_by_points
        store_tab(1)
      when 'Goals'
        @scores = sort_by_goals
        store_tab(2)
      when 'Pull-ups'
        @scores = sort_by_pull_ups
        store_tab(3)
      else
        @scores = sort_by_wins
        store_tab(0)
    end

  end

  def sort_by_wins
    Score.all.sort { |s1, s2| s2.wins <=> s1.wins}
  end

  def sort_by_points
    Score.all.sort { |s1, s2| s2.points <=> s1.points}
  end

  def sort_by_goals
    Score.all.sort { |s1, s2| s2.goals <=> s1.goals}
  end

  def sort_by_pull_ups
    Score.all.sort { |s1, s2| s2.pullUps <=> s1.pullUps}
  end

  def active_tab
    @active = 2
  end

  private
  def store_tab(tab)
    session[:sort_tab] = tab
  end

end
