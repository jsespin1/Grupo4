class Finanza < ActiveRecord::Base

	#Entonces quiero llamar esta clase con el fin de que llame a los request y traduzca los mensajes

	#Transferencias -> PROVEEDORES y FABRICA
	#Obtener TRANSFERENCIA
	#Obtener CUENTA FABRICA
	#

	def self.transferir(monto, origen, destino)
		Request.transferir(monto, origen, destino)
	end


	def self.getCuentaFabrica
		cuenta = Request.getCuentaFabrica
	end

	def self.getCuentaPropia
		cuenta = "572aac69bdb6d403005fb051"
	end

	def self.getCartola(fecha_inicio, fecha_fin, id_cuenta, limite)
	    Request.obtener_cartola(fecha_inicio, fecha_fin, id_cuenta, limite)
	end













end
