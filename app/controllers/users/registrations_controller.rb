class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper
  filter_access_to :all

  def create
    @user = User.new(sign_up_params)
    @user.created_by = current_user
    @user.password = User::DEFAULT_PASSWORD
    @user.password_confirmation = User::DEFAULT_PASSWORD

    @user.roles << Role.ci_find_by_name('barista')

    respond_to do |format|
      if @user.save
        format.html { redirect_to "/", notice: 'User was successfully created.  Please login with your PIN.' }
        format.json { render @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    super
  end

  def edit
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :pin, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :pin, :password, :password_confirmation, :current_password)
  end

end
