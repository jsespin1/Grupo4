class AlmacenController < ApplicationController

	def index 

		#Ftp.descargarFtp
		#Request.moverStock('571262b6a980ba030058a7aa','571262aaa980ba030058a242')
		Almacen.moverAlmacenDespacho("38","1")

		#almacenes = Request.getAlmacenesAll
		#almacenes.each do |a|
			#puts "Almacen ->" + a.inspect
			#skus = Request.getSKUs(a._id)
			#puts "   SKUs " + skus.inspect
		#end
		#numero = Request.getStock('571262aaa980ba030058a241','16')
		#almacenes = Request.getAlmacenesAll
		#puts "CHAMESITO TIENE SUEÑO " + numero.inspect
		#@almacenes = Request.getAlmacenesAll
		#puts "prueba jarita ->" + Compra.consultar_materia_prima(26).inspect
		#origin/compras
		#El siguiente método gatilla el proceso de compra ficticio SKU:38 QTY:340
		#Controlador.facturaFicticio("571682b543c20b03003d9ab7")
		#Almacen.revisarAlmacenRecepcion
		#Request.create_orden('b2b', 4, '38', '571262b8a980ba030058ab52', '571262b8a980ba030058ab52', 1513, DateTime.current + 6.days, 'jpp' )
		#@oc = Request.getOC("57127d2e8a9e6506000b998a")
		#id = "57136f3ba7aa2f03002639f4"
		#sku = 38
		#qty = 300
		#Controlador.procesar_oc(id)
		#Request.create_orden('b2b', 4, '38', '571262b8a980ba030058ab52', '571262b8a980ba030058ab52', 1513, 3563209336999, 'jpp' )
		#@oc = Request.getOC("57127d2e8a9e6506000b998a")
		#Ftp.showls
	end
	

	def show
		@almacen = params[:almacen]
		@skus = Request.getSKUs(params[:almacen]['_id'])
		#Obtenemos
		#productos = Request.getStock(params[:almacen]['_id'], s._id)	
	end

end
