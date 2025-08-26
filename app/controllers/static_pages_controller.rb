class StaticPagesController < ApplicationController
  before_action :authenticate_user!
  skip_load_and_authorize_resource

  def help
    if current_user
      redirect_to send("#{current_user.role}_dashboard_show_path")
    else
      redirect_to new_user_session_path
    end
  end
end
