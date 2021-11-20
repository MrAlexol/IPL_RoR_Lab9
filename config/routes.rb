Rails.application.routes.draw do
  root 'sequence#input'

  get 'sequence/input'
  get 'sequence/view'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
