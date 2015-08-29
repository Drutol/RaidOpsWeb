class UserSessionsController < ApplicationController
  skip_before_filter :require_login, except: [:destroy]
  def new
    if logged_in? then 
      redirect_to guilds_path 
    else
      @user = User.new
    end
  end

  def create
    if @user = login(params[:email], params[:password])
      #redirect_back_or_to(:users, notice: 'Login successful')
      if User.find_by_email(@user.email).guild_id != nil then
          redirect_to Guild.find(User.find_by_email(@user.email).guild_id)
      else  
          redirect_to guilds_path
      end
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(guilds_path, notice: 'Logged out!')
  end
end