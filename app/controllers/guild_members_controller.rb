class GuildMembersController < ApplicationController


	def create
	    @guild = Guild.find(params[:guild_id])
	    @guild_member = @guild.guild_members.create(member_params)
	    redirect_to guild_path(@guild)
	end

	def edit
		if not authorized?(params[:guild_id]) then redirect_to guild_path(params[:guild_id]) end
		@member = GuildMember.find(params[:id])
		@guild = Guild.find(params[:guild_id])
	end

	def change

		guild = Guild.find(params[:guild_id])
		member = GuildMember.find(params[:id])
		if GuildMember.find(params[:id]).edit_flag then
			edit_member = GuildMember.find(params[:id])
		end
		if not member_params[:ep] then 
			nEP = member.ep
			nGP = member.gp

			nNet = member_params[:net]
			nTot = member.tot
			if (member_params[:net].to_i - member.net) > 0 then
				nTot = member.tot +	(member_params[:net].to_i - member.net)
			end 
		end

		if not member_params[:net] then
			nNet = member.net
			nTot = member.tot

			nEP = member_params[:ep]
			nGP = member_params[:gp]
		end
		if not edit_member then
			guild.guild_members.create!(:name => member.name,:ep => nEP,:gp => nGP,:pr => "%.2f"%(nEP.to_f/nGP.to_f),:str_class => member_params[:str_class],:str_role => member_params[:str_role],:tot => nTot,:net => nNet,:edit_flag => params[:id]) #TODO DKP
		else
			edit_member.update_attributes!(:name => member.name,:ep => nEP,:gp => nGP,:pr => "%.2f"%(nEP.to_f/nGP.to_f),:str_class => member_params[:str_class],:str_role => member_params[:str_role],:tot => nTot,:net => nNet) #TODO DKP
		end
		redirect_to guild_path(guild)
	end

	def undo
		GuildMember.find(params[:id]).destroy
		redirect_to guild_path(params[:guild_id])
	end

	def commit
		GuildMember.find(params[:id]).commit
		redirect_to guild_path(params[:guild_id])
	end
 
  private
    def member_params
      params.require(:guild_member).permit(:name, :ep ,:gp, :str_class,:str_role,:net,:tot)
    end
end
