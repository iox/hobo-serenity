# Install hook code here

# Comprobar carpetas. Si no existen, crearlas
unless File.exist?('informes')
  FileUtils.mkdir('informes')
end
unless File.exist?('app/views/plantillas_odt')
  FileUtils.mkdir('app/views/plantillas_odt')
end

#Copiar el ejemplo de plantilla
FileUtils.copy('vendor/plugins/hobo-serenity/ejemplo.odt','app/views/plantillas_odt/ejemplo.odt')
