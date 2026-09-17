Bureau::Engine.routes.draw do
  resource :settings, only: :show, controller: "settings"
  get "settings/:key", to: "sections#show", as: :section
end
