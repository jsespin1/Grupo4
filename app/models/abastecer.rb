class Abastecer < ActiveRecord::Base

	##Se encarga de revisar los niveles de inventario en los almacenes
	#(1) Para productos procesados, manda a producir según el nivel de inventario definido y la materia prima limitante.
	#(2) Para materias primas, si están bajo, manda a producir o comprar según corresponda.
	# => Pagar a fábrica antes de mandar a producir


	def self.revisaPP
		#Debemos revisar los niveles de SKUs 11 y 16
		#Debemos revisar los niveles de SKUs 11 y 16
		actual_11 = Controlador.getStock("11")
		actual_16 = Controlador.getStock("16")
		puts "Stock 16: " + actual_16.to_s
		minimo_11 = Producto.get_minimo("11")
		minimo_16 = Producto.get_minimo("16")
		puts "Minimo 16: " + minimo_16.to_s
		maximo_11 = Producto.get_maximo("11")
		maximo_16 = Producto.get_maximo("16")
		while actual_11 < minimo_11 || actual_11 < maximo_11
			#Aca iniciamos el proceso de compra a otros grupos
			cuenta_fab = Finanza.getCuentaFabrica
			#Se calcula el costo de mandar a producir un lote
			costo = costo_lote("38")
			#Luego, se le transfiere a la fábrica
			transferencia = Finanza.transferir(costo, Finanza.getCuentaPropia, cuenta_fab)
			lote = Producto.get_lote("38").to_i
			#Finalmente, se manda a producir
			produccion = Request.producir("38", transferencia._id, lote)
			puts "Produccion -> "+ produccion.inspect
			actual_38 = actual_38 + lote
		end
	end

	def self.revisarMPPropias
		#Debemos revisar los niveles de SKUs 11 y 16
		actual_38 = Controlador.getStock("38")
		actual_44 = Controlador.getStock("44")
		minimo_38 = Producto.get_minimo("38")
		minimo_44 = Producto.get_minimo("44")
		maximo_38 = Producto.get_maximo("38")
		maximo_44 = Producto.get_maximo("44")
		#Se revisan los niveles y se despacha
		arreglo = [0, 0]

		while actual_38 < minimo_38 
			#Primero, se debe pagar a la fábrica
			cuenta_fab = Finanza.getCuentaFabrica
			#Se calcula el costo de mandar a producir un lote
			costo = costo_lote("38")
			#Luego, se le transfiere a la fábrica
			transferencia = Finanza.transferir(costo, Finanza.getCuentaPropia, cuenta_fab)
			lote = Producto.get_lote("38").to_i
			puts "LOTEEE->  " + lote.to_s
			#Finalmente, se manda a producir
			produccion = Request.producir("38", transferencia._id, lote)
			puts "Produccion -> "+ produccion.inspect
			actual_38 = actual_38 + lote
			arreglo[0] = arreglo[0] + lote
		end

		while actual_44 < minimo_44 
			cuenta_fab = Finanza.getCuentaFabrica
			costo = costo_lote("44")
			transferencia = Finanza.transferir(costo, Finanza.getCuentaPropia, cuenta_fab)
			lote = Producto.get_lote("44").to_i
			produccion = Request.producir("44", transferencia._id, lote)
			puts "Produccion 44-> "+ produccion.inspect
			actual_44 = actual_44 + lote
			arreglo[1] = arreglo[1] + lote
		end		
		arreglo
	end
	

	def self.revisarmp
		

	end


	def self.pagarFabrica
		

	end

	def self.costo_lote(sku)
		costo_total = 0
		costo_unidad = Producto.get_costo(sku).to_i
		cantidad_lote = Producto.get_lote(sku).to_i
		costo_total = costo_unidad*cantidad_lote
	end



end
