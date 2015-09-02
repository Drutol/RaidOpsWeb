class ApiController < ApplicationController
  respond_to :json
  skip_before_filter  :verify_authenticity_token
  skip_before_filter :require_login, only: [:get_status, :import]
  def get_status
  	
  	if not params[:key] then
  		respond_to do |format| 
  			format.json {render :json => {:msg =>"No data", :code => 1}}
  		end
  		return 
  	end

  	key = ApiKey.find_by_key(params[:key])
    if key then guild = Guild.find(key.guild_id) end

  	if not key or not guild then 
  		respond_to do |format|
  			format.json {render :json => {:msg =>"Unknown key", :code => 2}}
  		end
  		return
  	end

  	respond_to do |format|
		format.json {render :json => {:msg => guild.import_status, :code => 3}}
	end

  end

  def import
  	if not params[:json] or not params[:key] then
  		respond_to do |format| 
  			format.json {render :json => {:msg =>"No data", :code => 1}}
  		end
  		return 
  	end

  	key = ApiKey.find_by_key(params[:key])
    if key then guild = Guild.find(key.guild_id) end

  	if not key or not guild then 
  		respond_to do |format|
  			format.json {render :json => {:msg =>"Unknown key", :code => 2}}
  		end
  		return
  	end

  	if key.cooldown then
  		cd = Time.now.to_i - key.cooldown
  		if cd > 0 then
	  		respond_to do |format|
	  			format.json {render :json => {:msg =>"Key is on cooldown", :code => 4}}
	  		end
  		end
  	end
  	if not key.triggered then key.update_attribute(:triggered, 0) end
  	key.update_attributes(:cooldown => Time.now.to_i+360,:triggered => key.triggered + 1)

  	Thread.new do
  	  guild.import(params)
	  ActiveRecord::Base.connection.close
	end

  	respond_to do |format|
		format.json {render :json => {:msg =>"Import in progress", :code => 3}}
	end


  end
end
