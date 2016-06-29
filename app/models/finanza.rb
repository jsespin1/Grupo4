class Finanza < ActiveRecord::Base

	#Entonces quiero llamar esta clase con el fin de que llame a los request y traduzca los mensajes

	#Transferencias -> PROVEEDORES y FABRICA
	#Obtener TRANSFERENCIA
	#Obtener CUENTA FABRICA
	#

	def self.transferir(monto, origen, destino)
		#Devuelve objeto tipo Transaccion
		respuesta = Request.transferir(monto, origen, destino)
		respuesta.save
		respuesta
	end


	def self.getCuentaFabrica
		respuesta = Request.getCuentaFabrica
		cuenta = respuesta["cuentaId"]
	end

	def self.getCuentaPropia
		#571262c3a980ba030058ab5f
		cuenta = ""
		if Rails.env == 'development'
            cuenta = "571262c3a980ba030058ab5f"
        else
            cuenta = "572aac69bdb6d403005fb051"
        end
		cuenta
	end

	def self.getCuentaDestino(idDestino)
		Controlador.cuentaDestino(idDestino)
	end



	def self.getCartola(fecha_inicio, fecha_fin, id_cuenta, limite)
	    Request.obtener_cartola(fecha_inicio, fecha_fin, id_cuenta, limite)
	end













end
