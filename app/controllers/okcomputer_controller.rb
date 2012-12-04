class OKComputerController < ApplicationController
  layout nil

  def index
    results = OKComputer.results

    respond_to do |format|
      format.text { render text: results.values.join("\n") }
      format.json { render json: results.to_json }
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
