module GuildsHelper

	def authorized?(id)
		if current_user and User.find_by_email(current_user.email).guild_id and User.find_by_email(current_user.email).guild_id == id then return true else return false end
	end
end
