module Admin
  class UsersController < ApplicationController
    before_action :require_login
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
      authorize User
      @users = policy_scope(User).order(:created_at)
    end

    def show
      authorize @user
    end

    def edit
      authorize @user
    end

    def update
      authorize @user

      if @user == current_user && user_params[:role].present? && user_params[:role] != "admin"
        redirect_to admin_users_path, alert: "Du kannst dich nicht selbst entprivilegieren." and return
      end

      if @user.update(user_params)
        redirect_to admin_users_path, notice: "Benutzer wurde aktualisiert."
      else
        render :edit
      end
    end

    def destroy
      authorize @user
      if @user == current_user
        redirect_to admin_users_path, alert: "Du kannst dich nicht selbst löschen."
        return
      end
      @user.destroy
      redirect_to admin_users_path, notice: "Benutzer gelöscht."
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :role, :password, :password_confirmation)
    end
  end
end
