class WeibosController < ApplicationController
    before_filter :authenticate_user!
    def index
      @wb_msgs = WbMsg.take( 100  )
      @appkey = "2601417764"
      @appsecret = "510fd9a175bc9f24d05514a6708c9517"
      @state = params[:state]
      @code = params[:code]
    end

    def show

    end

    def post
      @user = User.find(params[:id])
      @wb_msgs = WbMsg.where("auther_id = ?", params[:id])
    end
end
