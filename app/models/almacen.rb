class Almacen < ActiveRecord::Base

	has_many :skus

	def self.getAlmacenes(almacenes)
		arreglo = []
		almacenes.each do |b|
			a = Almacen.new(:_id => b['_id'], :grupo => b['grupo'], :pulmon => b['pulmon'], 
				:despacho => b['despacho'], :recepcion => b['recepcion'], :totalSpace => b['totalSpace'], 
				:usedSpace => b['usedSpace'], :v => b['__v'])
			arreglo.push(a)
		end
		arreglo
	end
end
