class ApiController < ApplicationController
  respond_to :json
  skip_before_filter  :verify_authenticity_token
  skip_before_filter :require_login, only: [:get_status, :import]
  def get_status
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

  	Thread.new do
  	  guild.import(params)
	  ActiveRecord::Base.connection.close
	end

  	respond_to do |format|
		format.json {render :json => {:msg =>"Import in progress", :code => 3}}
	end


  end
end
