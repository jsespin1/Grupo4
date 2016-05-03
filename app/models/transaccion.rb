class Transaccion < ActiveRecord::Base

	  #t.string :_id
      #t.datetime :fecha_creacion
      #t.string :cuenta_origen
      #t.string :cuenta_destino
      #t.float :monto

      def self.getTran(respuestaServ)
      	puts "Generando Trans" + respuestaServ.inspect
      	#Generar la factura


      end


end
