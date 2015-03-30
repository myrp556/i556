class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    users = User.all
    @users_info = []
    users.each do |user|
      @users_info << { "email" => user.email, "screen_name" => user.screen_name, "id" => user.id  }
    end
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @users_info, status: "success" }
    end
  end
end
