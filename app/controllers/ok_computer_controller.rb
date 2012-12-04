class OkComputerController < ApplicationController
  layout nil
  respond_to :text, :json

  def index
    checks = OKComputer.registered_checks

    respond_with checks
  end

  def show
    check = OKComputer.registered_check(params[:check])

    respond_to do |format|
      format.text { render text: check.to_text }
      format.json { render json: check.to_json }
    end
  end
end
