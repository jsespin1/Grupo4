class Saldo < ActiveRecord::Base


	def self.saveSaldo(saldo)
		valor = saldo.to_i
		puts "SALDO-------------"
		puts valor 
		nuevo = Saldo.new(monto: valor)
		nuevo.save
	end

end
