# HoboSerenity

logger = RAILS_DEFAULT_LOGGER
#logger.info('patata: el plugin hobo_serenity.rb se ha ejecutado')

# Este módulo se añadirá al modelo
module HoboSerenity

    def generar_informe
#      logger.info('patata: se ha ejecutado el método generar_informe del módulo HoboSerenity')
#      logger.info('patata: el nombre de la orden es ' + name)
#      logger.info('patata: el nombre de la clase es ' + self.class.to_s.downcase)

      #Comprobar que la carpeta destino existe
      modelo = self.class.to_s.downcase
      carpeta_destino = 'informes/'
      unless File.exist?(carpeta_destino)
        FileUtils.mkdir(carpeta_destino)
      end
      
      # Preparar las URLs de los ficheros
      plantilla = 'app/views/plantillas_odt/'+ modelo +'.odt'
      odt_destino = 'informes/'+ modelo +'/' + nombre_informe + '.odt'

      # Generar ODT con Serenity
      render_odt plantilla, odt_destino
      
    end
    
    
    def ruta_descarga_odt
      modelo = self.class.to_s.downcase
      return "/"+ modelo +"s/descargar_odt/" + id.to_s + '?h=' + rand.to_s
    end  

end


#Este módulo se añadirá al controlador para permitir las descargas
module HoboSerenityController
   def descargar_odt
     #Necesitamos conocer el nombre de la clase del Modelo
     nombre_clase_modelo = self.class.to_s.first(-11)
     #Utilizamos eval para buscar el objeto del modelo
     modelo = eval(nombre_clase_modelo).find(params[:id])
     #Elaboramos la ruta del fichero y se lo devolvemos al usuario
     ruta = 'informes/' + modelo.class.to_s.downcase + "/" + modelo.nombre_informe + ".odt"
     send_file ruta
   end 
   
   def descargar_pdf
     #Necesitamos conocer el nombre de la clase del Modelo
     nombre_clase_modelo = self.class.to_s.first(-11)
     #Utilizamos eval para buscar el objeto del modelo
     modelo = eval(nombre_clase_modelo).find(params[:id])
     #Elaboramos la ruta del fichero y se lo devolvemos al usuario
     ruta = 'informes/' + modelo.class.to_s.downcase + "/" + modelo.nombre_informe + ".pdf"
     send_file ruta
   end
end

