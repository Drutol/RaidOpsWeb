module ApplicationHelper

 def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end
 
  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert alert-info fade in") do 
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message 
            end)
    end
    nil
  end

  def authorized?(id)
    if current_user and User.find_by_email(current_user.email).guild_id and User.find_by_email(current_user.email).guild_id == id or current_user and User.find_by_email(current_user.email).assistant and User.find_by_email(current_user.email).assistant == id then return true else return false end
  end

  def authorized_full?(id)
    if current_user and User.find_by_email(current_user.email).guild_id and User.find_by_email(current_user.email).guild_id == id then return true else return false end
  end

  def get_class_for_item_qual(qual)
    if qual == 1 then return "bs-callout bs-callout-item-white"
    elsif qual == 2 then return "bs-callout bs-callout-item-white"
    elsif qual == 3 then return "bs-callout bs-callout-item-green"
    elsif qual == 4 then return "bs-callout bs-callout-item-blue"
    elsif qual == 5 then return "bs-callout bs-callout-item-epic"
    elsif qual == 6 then return "bs-callout bs-callout-item-orange"
    elsif qual == 7 then return "bs-callout bs-callout-item-pink"
    end   
  end

  def get_item_entry_and_source(item)
    id = item.item_id
    entry = ItemDb.find_by_item_id(id) 
    if entry then
      sprite = entry.sprite

      if sprite.include?("IconSprites:") then
        sprite = sprite[12..-1]
      elsif sprite.include?("ClientSprites:") then
        sprite = sprite[14..-1]
      end

      source = ""
      if not File.file?("#{Rails.root}/app/assets/images/item_icons/#{sprite}") then
        source = "http://www.jabbithole.com/assets/icons/#{sprite.downcase}.png"
      end

      return entry , source , sprite , item
    end
    return nil , nil, nil , item
  end

  def get_small_icon(id)
    entry = ItemDb.find_by_item_id(id) 
    if entry then
      sprite = entry.sprite

      if sprite.include?("IconSprites:") then
        sprite = sprite[12..-1]
      elsif sprite.include?("ClientSprites:") then
        sprite = sprite[14..-1]
      end

      source = ""
      if not File.file?("#{Rails.root}/app/assets/images/item_icons/#{sprite}") then
        source = "http://www.jabbithole.com/assets/icons/#{sprite.downcase}.png"
      end

      if source == "" then
        return image_tag "item_icons/#{sprite}" ,:style => "width:23px;height:23px"
      else
        return image_tag source ,:style => "width:23px;height:23px"
      end
    end
    return link_to ""
  end
end
