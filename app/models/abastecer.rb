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
			#Finalmente, se manda a producir
			produccion = Request.producir("38", transferencia._id, lote)
			puts "Fabrica Respuesta 33-> "+ produccion.inspect
			actual_38 = actual_38 + lote
			arreglo[0] = arreglo[0] + lote
			puts "Disponibilidad: " + actual_38.to_s
		end

		while actual_44 < minimo_44 
			cuenta_fab = Finanza.getCuentaFabrica
			costo = costo_lote("44")
			transferencia = Finanza.transferir(costo, Finanza.getCuentaPropia, cuenta_fab)
			lote = Producto.get_lote("44").to_i
			produccion = Request.producir("44", transferencia._id, lote)
			puts "Fabrica Respuesta 44-> "+ produccion.inspect
			actual_44 = actual_44 + lote
			arreglo[1] = arreglo[1] + lote
			puts "Disponibilidad: " + actual_44.to_s
		end		
		arreglo
	end
	

	#------------------------------------ Compra B2B ---------------------------------------------#

	def self.comprarB2B
		#Tenemos que procesar Pasta de Trigo -> Harina 23 (G7), Sal 26 (G8) y Huevo 2 (G2)
		#Tenemos que procesar Margarina -> Aceite de Maravilla 4 (G11)
		#Revisamos niveles de cada uno
		#Arreglo de arreglos con [sku, cantidadDispSKU, grupo] para cada SKU
		array_disp = [ [23, Controlador.getStock("23")] , [26, Controlador.getStock("26")], [2, Controlador.getStock("2")], [4, actual_4 = Controlador.getStock("4")]]
		#Si estamos bajo los niveles de cada uno, consultamos stock
		array_disp.each do |sku_disp|
			sku = sku_disp[0]
			disponible = sku_disp[1]
			#Consultamos stock al grupo correspondiente
			stock = Compra.consultar_materia_prima(sku)

			#QUEDA PENDIENTE POR FALTA DE STOCK DE LOS OTROS GRUPOS
		end

	end


	def self.pagarFabricarPP
		#PENDIENTE, DEPENDE DEL METODO COMPRAR B2B PARA ABASTECERSE DE LAS MATERIAS PRIMAS
		#Fabricar Pasta De Trigo 6 (Sku:4) y Margarina
		

	end


	def self.costo_lote(sku)
		costo_total = 0
		costo_unidad = Producto.get_costo(sku).to_i
		cantidad_lote = Producto.get_lote(sku).to_i
		costo_total = costo_unidad*cantidad_lote
	end



end
