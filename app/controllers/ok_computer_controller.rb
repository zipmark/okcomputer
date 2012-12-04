class OkComputerController < ApplicationController
  layout nil

  def index
    checker = OKComputer.checker

    respond_to do |format|
      format.text { render text: checker.to_text }
      format.json { render json: checker.to_json }
    end
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
