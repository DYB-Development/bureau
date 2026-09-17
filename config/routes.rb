Bureau::Engine.routes.draw do
  resource :settings, only: :show, controller: "settings"
end
