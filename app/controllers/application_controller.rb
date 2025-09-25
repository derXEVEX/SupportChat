class ApplicationController < ActionController::Base
  include Pundit

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  rescue_from Pundit::NotAuthorizedError do |_exception|
    redirect_to root_path, alert: "Du hast keine Berechtigung dafür."
  end

  private

  def require_login
    redirect_to login_path, alert: "Bitte einloggen." unless current_user
  end

  before_action :set_paper_trail_whodunnit

  def user_for_paper_trail
    current_user&.id
  end

  def authenticate_user!
    unless current_user
      flash[:alert] = "Du musst angemeldet sein, um diese Seite zu sehen."
      redirect_to login_path
      return
    end
  end
end
