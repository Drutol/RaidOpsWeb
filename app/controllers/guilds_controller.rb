class GuildsController < ApplicationController
	skip_before_filter :require_login, only: [:index, :show,:items_all]
	def new
		if User.find_by_email(current_user.email).guild_id != nil then
			redirect_to Guild.find(User.find_by_email(current_user.email).guild_id) , notice: 'You have already created guild , remove this one first'
		else
			@guild = Guild.new
		end
	end

	def show
   		@guild = Guild.find(params[:id])
   		@members_grid = initialize_grid(@guild.guild_members,:order => 'guild_members.pr',:order_direction => 'desc')
  	end

  	def index
  		@guilds_grid = initialize_grid(Guild.all)
  	end
  	def download
	  send_file("#{Rails.root.to_s}/app/guild_data/json_import/guild_#{params[:id]}.txt") if File.exist?("#{Rails.root.to_s}/app/guild_data/json_import/guild_#{params[:id]}.txt")
	  redirect_to Guild.find(params[:id])
	end

  	def items_all
  	  @guild = Guild.find(params[:id])
  	  @item_owners = {}
  	  Item.where(of_guild_id: params[:id]).each do |item|
  	  	@item_owners[item.timestamp] = item.of_member_id
  	  end
      @items_grid = initialize_grid(Item.where(of_guild_id: params[:id]))
    end

  	def edit
  		@guild = Guild.find(params[:id])
	end

	def create
	  	@guild =  Guild.new(guild_params)
	 
	 	if @guild.save
			User.find_by_email(current_user.email).update_attribute(:guild_id , @guild.id)

	 		redirect_to @guild , notice: 'Guild created'
	 	else
	 		render 'new' ,  notice: 'Guild creation fail'
	 	end
	end

	def update
	  @guild = Guild.find(params[:id])
	 
	  if @guild.update(guild_params)
	    redirect_to @guild
	  else
	    render 'edit'
	  end
	end

	def destroy
		@guild = Guild.find(params[:id])
		Item.where(:of_guild_id => params[:id].to_i).delete_all
		for guild_member in @guild.guild_members do
			Log.where(:guild_member_id => guild_member.id).delete_all
		end
		@guild.guild_members.destroy
		@guild.destroy
		path = "#{Rails.root.to_s}/app/guild_data/json_import/guild_#{params[:id]}.txt"
		File.delete(path) if File.exist?(path)
		User.find_by_email(current_user.email).update_attribute(:guild_id , nil)
		redirect_to guilds_path , notice: 'Guild deleted successfully.'
	end

	def upload
		@guild = Guild.find(params[:id])
	end

	def import
		@guild = Guild.find(params[:id])
		strState , c_counter , u_counter , l_counter , i_counter = @guild.import(params)
		if strState == "success" then
			redirect_to @guild , notice: "Import successfull: Created #{c_counter.to_s} entries , updated #{u_counter.to_s} entries. Processed #{i_counter} items and #{l_counter} logs."
		elsif strState == "fail" then
			redirect_to upload_guild_path(@guild) , notice: 'Invalid data'
		else
			redirect_to upload_guild_path(@guild) , notice: strState
		end
	end

	private
		def guild_params
	  		params.require(:guild).permit(:name, :owner, :realm)
		end
end
