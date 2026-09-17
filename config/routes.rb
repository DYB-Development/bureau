Bureau::Engine.routes.draw do
  get "/", to: "settings#show", as: :settings
  get "/:key", to: "sections#show", as: :section
  patch "/:key", to: "sections#update"
end
