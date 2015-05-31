class ItemsController < ApplicationController
  	skip_before_filter :require_login, only: [:index, :show]
    def index
      @guild = Guild.find(params[:guild_id])
  		for member in @guild.guild_members do
  			if member.id.to_i == params[:guild_member_id].to_i then
          if not member.edit_flag then
  				  @member = member
            @items_grid = initialize_grid(member.items,:name => 'items_grid',:order => 'items.timestamp' ,:order_direction => 'desc')         
            @logs_grid = initialize_grid(member.logs,:name => 'logs_grid',:order => 'logs.n_date' ,:order_direction => 'desc')
  				  break
          else
            redirect_member = GuildMember.find(member.edit_flag)
            @member = redirect_member
            @items_grid = initialize_grid(redirect_member.items,:name => 'items_grid')         
            @logs_grid = initialize_grid(redirect_member.logs,:name => 'logs_grid')
          end
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
