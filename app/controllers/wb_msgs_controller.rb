class WbMsgsController < ApplicationController
    def create
      @wb_msg = WbMsg.new(wb_msg_para)
      @wb_msg.save
      redirect_to weibo_path
    end
    def new
      @wb_msg = WbMsg.new
    end
    private
      def wb_msg_para
        params.require(:wb_msg).permit(:auther, :content, :user_id)
      end
end
