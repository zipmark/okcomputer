module OkComputer
  class OkComputerController < ActionController::Base
    layout nil

    if Rails::VERSION::MAJOR < 5
      before_filter :authenticate
    else
      before_action :authenticate
    end

    if OkComputer.analytics_ignore && defined?(NewRelic::Agent::Instrumentation::ControllerInstrumentation)
      include NewRelic::Agent::Instrumentation::ControllerInstrumentation
      newrelic_ignore if respond_to?(:newrelic_ignore)
    end

    rescue_from OkComputer::Registry::CheckNotFound do |e|
      respond_to do |f|
        if Rails::VERSION::MAJOR < 5
          f.any(:text, :html) { render text: e.message, status: :not_found }
        else
          f.any(:text, :html) { render plain: e.message, status: :not_found }
        end
        f.json { render json: { error: e.message }, status: :not_found }
      end
    end

    def index
      checks = OkComputer::Registry.all
      checks.run

      respond checks, status_code(checks)
    end

    def show
      check = OkComputer::Registry.fetch(params[:check])
      check.run

      respond check, status_code(check)
    end

  private

    def respond(data, status)
      respond_to do |format|
         format.any(:text, :html) do
           if Rails::VERSION::MAJOR < 5
             render text: data, status: status
           else
             render plain: data, status: status
           end
         end
         format.json { render json: data, status: status }
      end
    end

    def status_code(check)
      check.success? ? :ok : :error
    end

    def authenticate
      if OkComputer.requires_authentication?(params)
        authenticate_or_request_with_http_basic do |username, password|
          OkComputer.authenticate(username, password)
        end
      end
    end
  end
end
