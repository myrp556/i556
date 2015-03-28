require 'net/https'
require 'uri'
require 'json'

def post_api(api, args)
    uri = URI.parse api
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri)
    req.set_form_data(args)
    response = http.request(req)
    JSON.load(response.body)
end

def get_api(api, args)
    uri = URI.parse api
    uri.query = args.collect { |a| "#{a[0]}=#{URI::encode(a[1].to_s)}"  }.join('&')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(req)
    JSON.load(response.body)
end

def access_token_inval(access_token)
    @r1 = post_api("https://api.weibo.com/oauth2/get_token_info", { :access_token => access_token })
    if @r1["error"]
      return true
    end
    false
end

class WeibosController < ApplicationController
    before_filter :authenticate_user!
    def index
      @wb_msgs = current_user.wb_msgs
      @appkey = "2601417764"
      @appsecret = "510fd9a175bc9f24d05514a6708c9517"
      @state = params[:state]
      @code = params[:code]
      @access_token = current_user.access_token
      @h = { "a" => 1, "b" => 2 }
      @j = @h.to_json
      if (@state && @code)
        @data = post_api("https://api.weibo.com/oauth2/access_token", {:client_id => @appkey, :client_secret => @appsecret, :grant_type => "authorization_code", :redirect_uri => "http://i556.herokuapp.com/weibo", :code => @code})
        @access_token = @data["access_token"]
        if @access_token
          current_user.access_token = @access_token
          current_user.save
        end
      end
      @info = access_token_inval( @access_token )
      if (!@access_token)
      end
      @colle = {}
      if (@access_token)
        @msgs = get_api("https://api.weibo.com/2/statuses/user_timeline.json", {:access_token => @access_token, :count => 100})
        if !@msgs["error"]
          current_user.screen_name = @msgs["statuses"][0]["user"]["screen_name"]
          current_user.save
          @colle = { "name" => @msgs["statuses"][0]["user"]["screen_name"], "texts" => [] }

          for msg in @wb_msgs
            msg.destroy
          end

          for status in @msgs["statuses"]
            @colle["texts"] << { "text" => status["text"], "created_at" => status["created_at"] }
            msg = WbMsg.new( :user_id => current_user.id, :content => status["text"], "auther" => current_user.screen_name, "created_date" => status["created_at"] )
            msg.save
          end
          @wb_msgs = current_user.wb_msgs
        end
      end

    end

    def show
      @users = User.all
    end

    def post
      @user = User.find(params[:id])
      if @user
        @wb_msgs = @user.wb_msgs 
      end
    end
end
