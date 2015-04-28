class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :require_login, only: [:index, :new, :create ,:activate]
  # GET /users
  # GET /users.json
  def index
    if current_user and current_user.email == "dogier140@poczta.fm" then
      @users = User.all
    else
      redirect_to guilds_path
    end
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      redirect_to(login_path, :notice => 'User was successfully activated.')
    else
      not_authenticated
    end
  end
  
  def show
     if not current_user or current_user.email != "dogier140@poczta.fm" then
        redirect_to guilds_path
     end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
      if not current_user then
          redirect_to guilds_path
      else
          if current_user.id.to_f != params[:id].to_f then
            redirect_to guilds_path
          end
      end 
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_path, notice: 'Check your email for activation link.' }
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
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if User.find_by_email(current_user.email).id == params[:id].to_i then
        @user = User.find(params[:id])
      else
        redirect_to guilds_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :guild_id)
  end
end
