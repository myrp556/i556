class WeibosController < ApplicationController
    before_filter :authenticate_user!
    def index
      @wb_msgs = WbMsg.take( 100  )
    end

    def show

    end
end
