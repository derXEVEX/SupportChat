class DashboardController < ApplicationController
  before_action :require_login

  def index
  end

  def change_email
    if params[:email].present?
      current_user = User.find(session[:user_id])
      current_user.request_email_change(params[:email])
      redirect_to dashboard_path, notice: "Bestätigungslink wurde an die neue E-Mail gesendet."
    else
      redirect_to dashboard_path, alert: "Bitte gib eine gültige E-Mail-Adresse ein."
    end
  end

  private

  def require_login
    unless session[:user_id] && User.exists?(session[:user_id])
      redirect_to login_path, alert: "Du musst dich zuerst einloggen."
    end
  end
end