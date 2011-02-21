# HoboSerenity

# For debugging: you need to call 'logger' like this before using it
# logger = RAILS_DEFAULT_LOGGER

# This module will be added to the model
module HoboSerenity

    # We include this in order to use "number_to_currency" in the ODT template
    include ActionView::Helpers::NumberHelper

    def create_document (document_path, template_name)
      # "ODT_PATH" is the main folder where every document is saved
      # "document_path" can have subfolders
      # Here we prepare "document_folder" based on the two previous variables
      document_folder = ODT_PATH
      document_path_split = document_path.split('/')
      document_path_split.each_with_index {|x, y| 
        if (y != document_path_split.length-1)
          document_folder += x + '/'
        end
      }
      
      # if "document_folder" doesn't exist, create it
      unless File.exist?(document_folder)
        FileUtils.mkdir_p(document_folder)
      end
      
      # Prepare the files paths
      template = 'app/views/odt_templates/'+ template_name +'.odt'
      odt_path = document_folder + document_path_split.last + '.odt'
      pdf_path = document_folder + document_path_split.last + '.pdf'

      # Generate ODT with Serenity
      render_odt template, odt_path
      
      # Convert to PDF with OpenOffice 
      # OpenOffice should be listening as Server in localhost:8100
      command = 'python ' +
          'vendor/plugins/hobo-serenity/lib/DocumentConverter.py ' +
          odt_path + ' ' + pdf_path
      system(command)
      
      # By default we delete the ODT
      unless KEEP_ODT
        File.delete(odt_path)
      end
      
    end
    
    
    # These are the paths that the download link will use
    def odt_download_path(document)
      model = self.class.to_s.downcase
      return "/"+ model +"s/download_odt/" + id.to_s +
              '?h=' + rand.to_s + '&document=' + document
    end
    
    def pdf_download_path(document)
      model = self.class.to_s.downcase
      return "/"+ model +"s/download_pdf/" + id.to_s + 
              '?h=' + rand.to_s + '&document=' + document
    end

end




# This additional module with be added to the controller to handle downloads
module HoboSerenityController
   def download_odt
     # In order to create the document first we need to access the model object
     controller_name = self.class.to_s.downcase 
     model_name = controller_name.split('scontroller')[0].humanize
     object = model_name.constantize.find(params[:id])
     
     # The template name is in params, and the document path is in the model
     template_name = params[:document]
     document_path = object.send(template_name)
     
     # Create the document
     object.create_document(document_path, template_name)     
     
     # Send the file to the user
     send_file ODT_PATH + document_path + '.odt'
   end 
   
   def download_pdf
     # In order to create the document first we need to access the model object
     controller_name = self.class.to_s.downcase 
     model_name = controller_name.split('scontroller')[0].humanize
     object = model_name.constantize.find(params[:id])
     
     # The template name is in params, and the document path is in the model
     template_name = params[:document]
     document_path = object.send(template_name)
     
     # Create the document
     object.create_document(document_path, template_name)     
     
     # Send the file to the user
     send_file ODT_PATH + document_path + '.pdf'
   end 
end

