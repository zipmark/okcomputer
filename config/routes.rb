OKComputer::Engine.routes.draw do
  match "/" => "ok_computer#show"
  match "/all" => "ok_computer#index"
end
