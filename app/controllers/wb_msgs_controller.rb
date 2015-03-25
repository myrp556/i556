class WbMsgsController < ApplicationController
    before_filter :authenticate_user!
    def create
      @wb_msg = WbMsg.new(wb_msg_para)
      @wb_msg.auther_id = current_user.id
      @wb_msg.save
      redirect_to weibo_path
    end
    def new
      @wb_msg = WbMsg.new
    end
    def edit
      @wb_msg = WbMsg.find(params[:id])
    end
    def update
      @wb_msg = WbMsg.find(params[:id])
      if @wb_msg.update(wb_msg_para)
        redirect_to weibo_path
      else
        render 'edit'
      end
    end
    def destroy 
      @wb_msg = WbMsg.find(params[:id])
      @wb_msg.destroy
      redirect_to weibo_path
    end
    private
      def wb_msg_para
        params.require(:wb_msg).permit(:auther, :content)
      end
end
