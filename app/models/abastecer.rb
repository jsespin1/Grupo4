class Abastecer < ActiveRecord::Base

	##Se encarga de revisar los niveles de inventario en los almacenes
	#(1) Para productos procesados, manda a producir según el nivel de inventario definido y la materia prima limitante.
	#(2) Para materias primas, si están bajo, manda a producir o comprar según corresponda.
	# => Pagar a fábrica antes de mandar a producir


	def self.revisarProcesados
		

		
	end

	def self.revisarmp
		

	end


	def self.pagarFabrica
		

	end



end
