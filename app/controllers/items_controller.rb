class ItemsController < ApplicationController
  	skip_before_filter :require_login, only: [:index, :show]
  	def index
  		@guild = Guild.find(params[:guild_id])
  		for member in @guild.guild_members do
  			if member.id.to_f == params[:guild_member_id].to_f then
          @member = member
  				@items_grid = initialize_grid(member.items,:name => 'items_grid')
          @logs_grid = initialize_grid(member.logs,:name => 'logs_grid')
  				break
  			end 
  		end
  	end

  	def show

  	end

  	def create
	    @guild = Guild.find(params[:guild_id])
  		for member in @guild.guild_members do
  			if member.id.to_f == params[:guild_member_id].to_f then
  				member.items.create(item_params)
  				break
  			end 
  		end
	    redirect_to guild_path(@guild)
	end
 
  private
    def item_params
      params.require(:item).permit(:ingame_id, :timestamp ,:of_member_id, :of_guild_id ,:gp_cost)
    end
end
