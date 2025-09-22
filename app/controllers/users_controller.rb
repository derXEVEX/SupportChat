class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: "Registrierung erfolgreich!"
    else
      render :new, status: :unprocessable_entity
    end
  end


  def confirm_email
    user = User.find_by(confirmation_token: params[:token])
    if user
      user.confirm_email!
      redirect_to dashboard_path, notice: "E-Mail-Adresse erfolgreich bestätigt!"
    else
      redirect_to dashboard_path, alert: "Ungültiger Bestätigungslink."
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
