Rails.application.routes.draw do

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  Spree::Core::Engine.routes.draw do
    get "/inicio" => "home#inicio"
    get "/exito" => "home#exito"
  end

  mount Spree::Core::Engine, at: '/'
        
  root 'almacen#index'

  get 'almacen/show', :as => :show_almacen

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1 do

      #---------------------------- API  ------------------------------#

      #Métodos para Stock
      get '/consultar/:_id' => 'b2b#getStock'

      #Método para recibir transaccion despues de pagada la factura
      get '/facturas/recibir/:id_factura' => 'b2b#facturar'
      #Método recibir orden
      get '/oc/recibir/:_idorden' => 'b2b#analizarOC'

      #Método para recibir transaccion despues de pagada la factura
      get '/pagos/recibir/:idtrx' => 'b2b#transaccion'

      #-------------------- API Privada Control -------------------------#

      #Obtener Stock nuestras MP
      get '/productos/mp' => 'b2b#getMP'

      #Abastecer MP
      get '/abastecer/mp' => 'b2b#abastecerMP'

      #Descargar Ftp´s
      get '/ftp/descargar' => 'b2b#descargarFtp'

      #Procesar Ftp´s
      get '/ftp/procesar' => 'b2b#procesarFtp'

      #------------------------------------------------------------------#
      
      #Métodos que recibe transaccion y factura -> despacha
      #Métodos para registro y token
      #Registrar grupo
       #post 'register_group' => 'b2b#create_group'
      #Obtener token
       #get 'get_token' => 'b2b#get_token'
      #Métodos para orden de compra
       #post 'create_order' => 'b2b#create_order'
       #delete 'canceled_order' => 'b2b#canceled_order'
       #put 'accepted_order' => 'b2b#accepted_order'
       #put 'rejected_order' => 'b2b#rejected_order'
      #Métodos para las facturas
       #post 'issued_invoice' => 'b2b#issued_invoice'
       #put 'invoice_paid' => 'b2b#invoice_paid'
       #put 'rejected_invoice' => 'b2b#rejected_invoice'
      #Documentacion
       #get 'documentation' => 'b2b#documentation', defaults: {format: 'html'}
      #
       #get 'bank_account' => 'b2b#bank_account'
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
