class StaticPagesController < ApplicationController
  before_action :logged_in_user

  def help; end
end
