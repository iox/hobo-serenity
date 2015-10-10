# Install hook code here

# Check if odt templates folder exists
unless File.exist?('app/views/odt_templates')
  FileUtils.mkdir('app/views/odt_templates')
end

# Copy example template
FileUtils.copy('vendor/plugins/hobo-serenity/example.odt','app/views/odt_templates/example.odt')
