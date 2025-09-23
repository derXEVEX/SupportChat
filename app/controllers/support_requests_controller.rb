
class SupportRequestsController < ApplicationController
  before_action :require_login
  before_action :set_support_request, only: [:show, :update, :claim]
  before_action :require_admin_or_supporter, only: [:index, :claim, :update]

  def index
    @support_requests = SupportRequest.includes(:user, :category).order(created_at: :desc)
  end

  def my_requests
    @support_requests = current_user.support_requests.includes(:category).order(created_at: :desc)
  end

  def new
    @support_request = SupportRequest.new
    @categories = Category.all
  end

  def create
    @support_request = current_user.support_requests.new(support_request_params)
    @support_request.status = "offen"

    if @support_request.save

      @support_request.messages.create(
        content: params[:support_request][:initial_message],
        user: current_user
      )
      redirect_to my_requests_support_requests_path, notice: "Support-Anfrage wurde erfolgreich erstellt."
    else
      @categories = Category.all
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @messages = @support_request.messages.includes(:user).order(:created_at)
    @message = Message.new
  end

  def update
    if @support_request.update(update_params)
      redirect_to support_request_path(@support_request), notice: "Status aktualisiert."
    else
      redirect_to support_request_path(@support_request), alert: "Status konnte nicht aktualisiert werden."
    end
  end

  def destroy
    @support_request = SupportRequest.find(params[:id])

    unless current_user.admin?
      redirect_to support_request_path(@support_request), alert: "Du hast keine Berechtigung, diese Anfrage zu löschen."
      return
    end

    if @support_request.destroy
      redirect_to support_requests_path, notice: "Die Support-Anfrage wurde erfolgreich gelöscht."
    else
      redirect_to support_request_path(@support_request), alert: "Die Support-Anfrage konnte nicht gelöscht werden."
    end
  end



  def claim
    if @support_request.status == "offen"
      @support_request.update(status: "in Bearbeitung")
      redirect_to support_request_path(@support_request), notice: "Anfrage wurde übernommen."
    else
      redirect_to support_request_path(@support_request), alert: "Anfrage kann nicht übernommen werden."
    end
  end

  private

  def set_support_request
    @support_request = SupportRequest.find(params[:id])
  end

  def support_request_params
    params.require(:support_request).permit(:title, :category_id)
  end

  def update_params
    params.require(:support_request).permit(:status)
  end

  def require_admin_or_supporter
    unless current_user.admin? || current_user.supporter?
      redirect_to root_path, alert: "Zugriff verweigert."
    end
  end
end
