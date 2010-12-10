# Install hook code here

# Comprobar carpetas. Si no existen, crearlas
unless File.exist?('informes')
  FileUtils.mkdir('informes')
end
unless File.exist?('app/views/plantillas_odt')
  FileUtils.mkdir('app/views/plantillas_odt')
end

#Copiar el fichero dryml
FileUtils.copy('vendor/plugins/hobo_serenity/lib/hobo_serenity.dryml','app/views/taglibs/hobo_serenity.dryml')
FileUtils.copy('vendor/plugins/hobo_serenity/ejemplo.odt','app/views/plantillas_odt/ejemplo.odt')
