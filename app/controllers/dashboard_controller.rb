class DashboardController < ApplicationController
  before_action :require_login

  def index
    @user = current_user
  end

  def change_name
    if params[:name].present?
      current_user.update(name: params[:name])
      redirect_to dashboard_path, notice: "Name erfolgreich geändert."
    else
      redirect_to dashboard_path, alert: "Name darf nicht leer sein."
    end
  end

  def change_password
    if current_user.authenticate(params[:current_password])
      if params[:new_password] == params[:new_password_confirmation]
        if params[:new_password].length >= 12
          current_user.update(password: params[:new_password], password_confirmation: params[:new_password_confirmation])
          redirect_to dashboard_path, notice: "Passwort erfolgreich geändert."
        else
          redirect_to dashboard_path, alert: "Passwort muss mindestens 12 Zeichen lang sein."
        end
      else
        redirect_to dashboard_path, alert: "Passwort-Bestätigung stimmt nicht überein."
      end
    else
      redirect_to dashboard_path, alert: "Aktuelles Passwort ist falsch."
    end
  end

  def change_email
    if params[:email].present?
      current_user.request_email_change(params[:email])
      redirect_to dashboard_path, notice: "Bestätigungslink wurde an die neue E-Mail gesendet."
    else
      redirect_to dashboard_path, alert: "Bitte gib eine gültige E-Mail-Adresse ein."
    end
  end

  private

  def require_login
    redirect_to login_path unless session[:user_id]
  end
end
