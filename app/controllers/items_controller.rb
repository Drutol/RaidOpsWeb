class ItemsController < ApplicationController
  	skip_before_filter :require_login, only: [:index, :show]
    def index
      @guild = Guild.find(params[:guild_id])
  		for member in @guild.guild_members do
  			if member.id.to_i == params[:guild_member_id].to_i then
          @id = member.id.to_i
          if not member.edit_flag then
  				  @member = member
            @items_grid = initialize_grid(member.items,:name => 'items_grid',:order => 'items.timestamp' ,:order_direction => 'desc',:per_page => 15)         
            @logs_grid = initialize_grid(member.logs,:name => 'logs_grid',:order => 'logs.n_date' ,:order_direction => 'desc')
            @alts_grid = initialize_grid(member.alts,:name => 'alts_grid',:order => 'alts.name' ,:order_direction => 'desc',:per_page => 5)
  				  break
          else
            redirect_member = GuildMember.find(member.edit_flag)
            @member = member
            @items_grid = initialize_grid(redirect_member.items,:name => 'items_grid',:per_page => 15)         
            @logs_grid = initialize_grid(redirect_member.logs,:name => 'logs_grid')
            @alts_grid = initialize_grid(redirect_member.alts,:name => 'alts_grid',:per_page => 5)
          end
  			end 
  		end
      @slot_order_col1 = [16,15,2,3,0,5]
      @slot_order_col2 = [1,4,7,8,10,11]
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
