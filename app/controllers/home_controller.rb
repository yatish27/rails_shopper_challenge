class HomeController < ApplicationController
  layout 'home'
  before_action :logged_in?
  def index
  end
end