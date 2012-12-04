class OkComputerController < ApplicationController
  layout nil
  respond_to :text, :json

  def index
    checks = OKComputer.registered_checks

    respond_with checks
  end

  def show
    check_type = params[:check]
    result = OKComputer.perform_check(check_type)

    respond_to do |format|
      format.text { render text: result }
      format.json { render json: {check_type => result}.to_json }
    end
  end
end
