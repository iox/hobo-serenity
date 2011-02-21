# Install hook code here

# Check if odt templates folder exists
unless File.exist?('app/views/odt_templates')
  FileUtils.mkdir('app/views/odt_templates')
end

#Copiar el ejemplo de plantilla
FileUtils.copy('vendor/plugins/hobo-serenity/ejemplo.odt','app/views/plantillas_odt/ejemplo.odt')
