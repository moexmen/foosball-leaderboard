class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :pretty_format_date

  def pretty_format_date(date)
    date.strftime('%d %^b %Y')
  end
end
