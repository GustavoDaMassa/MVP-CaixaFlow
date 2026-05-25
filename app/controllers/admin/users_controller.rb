module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[show edit update destroy]

    def index
      @users = User.order(:name)
    end

    def show; end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: "Usuário criado com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      params_to_use = user_params
      params_to_use = params_to_use.except(:password, :password_confirmation) if params_to_use[:password].blank?

      if @user.update(params_to_use)
        redirect_to admin_users_path, notice: "Usuário atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: "Usuário removido."
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :role, :active, :password, :password_confirmation)
    end
  end
end
