ManybotsGardener::Engine.routes.draw do
  match 'toggle' => 'gardener#toggle', as: 'toggle'
  root :to => 'gardener#index'
end
