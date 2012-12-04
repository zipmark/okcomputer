class OkComputerController < ApplicationController
  layout nil
  respond_to :text, :json

  def index
    checks = OKComputer::Checks.registered_checks

    respond_with checks
  end

  def show
    check = OKComputer::Checks.registered_check(params[:check])

    respond_with check
  end
end
