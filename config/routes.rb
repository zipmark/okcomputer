Rails.application.routes.draw do
  match "/okcomputer" => "ok_computer#show", defaults: {check: "default"}, via: [:get, :options]
  match "/okcomputer/all" => "ok_computer#index", via: [:get, :options]
  match "/okcomputer/:check" => "ok_computer#show", via: [:get, :options]
end
