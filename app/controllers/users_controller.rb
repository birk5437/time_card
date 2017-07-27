class UsersController < ApplicationController
  filter_access_to :all
  before_action :set_user, only: [:show, :edit, :update, :destroy, :vote, :clock_in, :clock_out]

  # GET /users
  # GET /users.json
  def index
    # TODO: replace sort_order with acts_as_votable
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def clock_page
    @user = current_user
    @shift = @user.shifts.new
  end

  def clock_in
    # raise params.inspect
    if @user.clocked_out?
      @user.clock_in!(request.remote_ip)
      redirect_to "/", notice: 'User has been clocked in.'
    else
      redirect_to "/", error: 'ERROR: User is already clocked in!'
    end
  end

  def clock_out
    if @user.clocked_in?
      @user.clock_out!
      redirect_to "/", notice: 'User has been clocked out.'
    else
      redirect_to "/", error: 'ERROR: User is already clocked out!'
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.created_by = current_user
    @user.password = User::DEFAULT_PASSWORD
    @user.password_confirmation = User::DEFAULT_PASSWORD

    @user.roles << Role.ci_find_by_name('barista')

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    redirect_to hotels_path
    # respond_to do |format|
    #   if @user.update(user_params)
    #     format.html { redirect_to @user, notice: 'User was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @user }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    redirect_to hotels_path
    # @user.destroy
    # respond_to do |format|
    #   format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end


  private ##################################################################################################################################

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :admin, :first_name, :last_name, :pin)
    end
end
