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
      @appkey = "2601417764"
      @appsecret = "510fd9a175bc9f24d05514a6708c9517"
      @state = params[:state]
      @code = params[:code]
      @alert = {"msg" => nil, "error" => nil, "error_code" => nil, "type" => "success"}
      @access_token = current_user.access_token
      flag = false
      if (@state && @code)
        @data = post_api("https://api.weibo.com/oauth2/access_token", {:client_id => @appkey, :client_secret => @appsecret, :grant_type => "authorization_code", :redirect_uri => "http://i556.herokuapp.com/weibo", :code => @code})
        @access_token = @data["access_token"]
        if @access_token
          flag=true
          current_user.access_token = @access_token
          current_user.save
        end
        if @data["error"]
            flag=false
            @alert = { "type" => "warning", "error" => @data["error"], "error_code" => @data["error_code"] }
        end
      end
      @info = access_token_inval( @access_token )
      @colle = {}
      if (@access_token && flag)
        @msgs = get_api("https://api.weibo.com/2/statuses/user_timeline.json", {:access_token => @access_token, :count => 100})
        if !@msgs["error"]
          current_user.screen_name = @msgs["statuses"][0]["user"]["screen_name"]
          current_user.save
          @colle = { "name" => @msgs["statuses"][0]["user"]["screen_name"], "texts" => [] }
          tmp_msgs = current_user.wb_msgs
          for msg in tmp_msgs
            msg.destroy
          end

          for status in @msgs["statuses"]
            @colle["texts"] << { "text" => status["text"], "created_at" => status["created_at"] }
            msg = WbMsg.new( :user_id => current_user.id, :content => status["text"], "auther" => current_user.screen_name, "created_date" => status["created_at"] )
            msg.save
          end
          @alert = { "type" => "success", "msg" => "get statuses success, get #{@msgs['statuses'].length}." }
        else
            @alert = { "type" => "warning", "error" => @msgs["error"], "error_code" => @msgs["error_code"] }
        end
      end
      @wb_msgs = current_user.wb_msgs.order("created_date desc")
    end

    def show
      @users = User.all
    end

    def test
      
    end

    def post
      @para = params[:keywords]
      @user = User.find(params[:id])
      @wb_msgs = [] 
      if @user
        msgs = @user.wb_msgs.order("created_date desc") 
        msgs.each do |msg|
          @wb_msgs << { "content" => msg.content, "created_date" => msg.created_date }
        end
      end
      respond_to do |format|
        format.html { render :post }
        if @user
          if @user.screen_name 
            if @para
              @query = "http://api.yutao.us/api/keyword/<"
              @wb_msgs.each do |wb_msg|
                @query = @query.insert(-1, " "+wb_msg["content"])
              end
              @keywords = get_api(@query+">", {})
            else
              format.json { render json: @wb_msgs,  status: "success" }
            end
          else
            error = { "error" => "this user does not oauth." }
            format.json { render json: error, status: "fail" }
          end
        else
          error = { "error" => "no such a user" }
          format.json { render json: error,  status: "fail"}
        end
      end
    end
end
