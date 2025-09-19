class UserPolicy
  attr_reader :current_user, :user_record

  def initialize(current_user, user_record)
    @current_user = current_user
    @user_record = user_record
  end

  def index?
    current_user&.admin?
  end

  def show?
    current_user&.admin? || current_user == user_record
  end

  def edit?
    update?
  end

  def update?
    current_user&.admin?
  end

  def destroy?
    current_user&.admin? && current_user != user_record
  end

  class Scope
    def initialize(current_user, scope)
      @current_user = current_user
      @scope = scope
    end

    def resolve
      if @current_user&.admin?
        @scope.all
      else
        @scope.where(id: @current_user&.id)
      end
    end
  end
end
