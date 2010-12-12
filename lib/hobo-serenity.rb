# HoboSerenity

logger = RAILS_DEFAULT_LOGGER
#logger.info('patata: el plugin hobo_serenity.rb se ha ejecutado')

# Este módulo se añadirá al modelo
module HoboSerenity

    def generar_informe (ruta_informe, nombre_plantilla)
#      logger.info('patata: se ha ejecutado el método generar_informe del módulo HoboSerenity')
#      logger.info('patata: el nombre de la orden es ' + name)
#      logger.info('patata: el nombre de la clase es ' + self.class.to_s.downcase)
#      modelo = self.class.to_s.downcase

      #Lo primero: si "ruta_informe" tiene /, hay que comprobar que existe la carpeta
      carpeta_destino = 'informes/'
      ruta_informe_split = ruta_informe.split('/')
      logger.info('patata: la length es ' + ruta_informe_split.length.to_s)
      ruta_informe_split.each_with_index {|x, y| 
        if (y != ruta_informe_split.length-1)
          carpeta_destino += '/' + x
        end
        logger.info('patata: la y es ' + y.to_s)
      }
      logger.info('patata: la carpeta destino es ' + carpeta_destino)
      unless File.exist?(carpeta_destino)
        FileUtils.mkdir_p(carpeta_destino)
      end
      
      # Preparar las URLs de los ficheros
      plantilla = 'app/views/plantillas_odt/'+ nombre_plantilla +'.odt'
      odt_destino = 'informes/'+ ruta_informe + '.odt'
      pdf_destino = 'informes/'+ ruta_informe + '.pdf'

      # Generar ODT con Serenity
      render_odt plantilla, odt_destino
      
      #Pasar a PDF con OpenOffice
      comando_pdf = 'python ' +
          'vendor/plugins/hobo-serenity/lib/DocumentConverter.py ' +
          odt_destino + ' ' + pdf_destino
      logger.info ('patata: el comando PDF es ' + comando_pdf)
      system(comando_pdf)
    end
    
    
    def ruta_descarga_odt(ruta_fichero)
      modelo = self.class.to_s.downcase
      return "/"+ modelo +"s/descargar_odt/" + id.to_s + '?h=' + rand.to_s + '&ruta=' + ruta_fichero
    end
    
    def ruta_descarga_pdf(ruta_fichero)
      modelo = self.class.to_s.downcase
      return "/"+ modelo +"s/descargar_pdf/" + id.to_s + '?h=' + rand.to_s + '&ruta=' + ruta_fichero
    end

end


#Este módulo se añadirá al controlador para permitir las descargas
module HoboSerenityController
   def descargar_odt
     #Elaboramos la ruta del fichero y se lo devolvemos al usuario
     ruta = 'informes/' + params[:ruta] + ".odt"
     send_file ruta
   end 
   
   def descargar_pdf
     #Elaboramos la ruta del fichero y se lo devolvemos al usuario
     ruta = 'informes/' + params[:ruta] + ".pdf"
     send_file ruta
   end
end

