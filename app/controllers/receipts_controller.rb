class ReceiptsController < ApplicationController
  def show
    @receipt = Receipt.find_by(token: params[:token])
  end
end