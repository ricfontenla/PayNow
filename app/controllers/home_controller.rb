class HomeController < ApplicationController

  layout :verify_layout

  def index
  end

  private

  def verify_layout
    if admin_signed_in?
      'admin'
    elsif user_signed_in?
      'user'
    else
      'application'
    end
  end
end