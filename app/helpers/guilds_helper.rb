module GuildsHelper

  def authorized?(id)
    if current_user and User.find_by_email(current_user.email).guild_id and User.find_by_email(current_user.email).guild_id == id then return true end
    if current_user and User.find_by_email(current_user.email).assistant and User.find_by_email(current_user.email).assistant == id then return true end
   	return false
  end

  def authorized_full?(id)
    if current_user and User.find_by_email(current_user.email).guild_id and User.find_by_email(current_user.email).guild_id == id then return true else return false end
  end
end
