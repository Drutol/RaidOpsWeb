class GuildMembersController < ApplicationController
	skip_before_filter :require_login, only: [:import_gear]

	def create
	    @guild = Guild.find(params[:guild_id])
	    @guild_member = @guild.guild_members.create(member_params)
	    redirect_to guild_path(@guild)
	end

	def edit
		#if current_user and User.find_by_email(current_user.email).guild_id and User.find_by_email(current_user.email).guild_id == params[:guild_id] then
		@member = GuildMember.find(params[:id])
		@guild = Guild.find(params[:guild_id])
		#else
		#redirect_to guild_path(params[:guild_id])
		#end
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
			guild.guild_members.create!(:name => member.name,:ep => nEP,:gp => nGP,:pr => "%.#{guild.pr_precision}f"%(nEP.to_f/nGP.to_f),:str_class => member_params[:str_class],:str_role => member_params[:str_role],:tot => nTot,:net => nNet,:edit_flag => params[:id]) #TODO DKP
		else
			edit_member.update_attributes!(:name => member.name,:ep => nEP,:gp => nGP,:pr => "%.#{guild.pr_precision}f"%(nEP.to_f/nGP.to_f),:str_class => member_params[:str_class],:str_role => member_params[:str_role],:tot => nTot,:net => nNet) #TODO DKP
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

	def remove
		member = GuildMember.find(params[:id])
		if member.edit_flag then
			GuildMember.find(member.edit_flag).destroy
		end
		Item.where(:of_guild_id => params[:id].to_i).destroy_all
		member.logs.delete_all
		member.attendances.delete_all
		member.destroy
		redirect_to guild_path(params[:guild_id])
	end

	def import_gear
		member = GuildMember.find(params[:id])
		if member.pin == params[:pin].to_i then 
			for piece in member.gear_pieces do
				piece.gear_runes.destroy_all
				piece.destroy
			end
			begin
				hash = JSON.parse(params[:json])
				for key in hash.keys do
					if key == "tStats" then
						member.member_stats.destroy_all
						member.member_stats.create(:mox =>hash[key]['Mox'],:brut => hash[key]['Bru'],:ins => hash[key]['Wis'],:tech =>hash[key]['Tech'],:fin =>hash[key]['Dex'],:grit =>hash[key]['Sta'])
					else
						item = hash[key]
						piece = member.gear_pieces.create(:item_id => item['id'],:item_type => key)
						item["runes"].each do |rune|
							piece.gear_runes.create(:rune_id => rune)
						end
					end
				end
				redirect_to guild_guild_member_items_path(params[:guild_id],params[:id]) , notice: 'Upload successful'
			rescue
				redirect_to guild_guild_member_items_path(params[:guild_id],params[:id]) , notice: 'Invalid import code'
			end
		else
			redirect_to guild_guild_member_items_path(params[:guild_id],params[:id]) , notice: 'Invalid PIN'
		end
	end
 
  private
    def member_params
      params.require(:guild_member).permit(:name, :ep ,:gp, :str_class,:str_role,:net,:tot)
    end
end
