class WeibosController < ApplicationController
    before_filter :authenticate_user!
    def index
      @wb_msgs = WbMsg.take( 100  )
    end

    def show

    end

    def post
      @user = User.find(params[:id])
      @wb_msgs = WbMsg.where("auther_id = ?", params[:id])
    end
end
