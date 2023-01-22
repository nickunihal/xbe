require 'sidekiq/web'
Rails.application.routes.draw do

  root 'dashboard#home'

  get 'invoices/index'
  get 'invoices/show'
  get 'invoices/edit'
  get 'invoices/new'
  post 'invoices/create'
  patch 'invoices/update'
  get 'invoices/invoice_batches'
  get 'invoices/invoice_batch_new'
  post 'invoices/invoice_batch_create'

  get 'items/index'
  get 'items/edit'
  patch 'items/update'
  get 'items/new'
  post 'items/create'

  get 'invoices/listen_update'

  # require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'

end
