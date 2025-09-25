# app/controllers/activities_controller.rb
class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_supporter, only: [:admin_index]

  def index
    @activities = PaperTrail::Version.where(item_type: ['SupportRequest', 'Message'])
                                     .where(whodunnit: current_user.id.to_s)
                                     .order(created_at: :desc)
                                     .paginate(page: params[:page], per_page: 20)
  end

  def admin_index
    @activities = PaperTrail::Version.where(item_type: ['SupportRequest', 'Message', 'User'])
                                     .order(created_at: :desc)
                                     .paginate(page: params[:page], per_page: 20)
  end


  private

  def require_admin_or_supporter
    unless current_user.admin? || current_user.supporter?
      redirect_to root_path, alert: "Zugriff verweigert."
    end
  end


end
