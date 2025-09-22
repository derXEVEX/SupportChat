class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: "Angemeldet!"
    else
      flash.now[:alert] = "E-Mail oder Passwort falsch"
      render :new, status: :unprocessable_entity
    end
  end


  def destroy
  session.delete(:user_id)
  redirect_to login_path, notice: "Du wurdest erfolgreich abgemeldet."
end

end
