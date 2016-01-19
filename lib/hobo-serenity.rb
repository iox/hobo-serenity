# HoboSerenity

# For debugging: you need to call 'logger' like this before using it
#logger = RAILS_DEFAULT_LOGGER

# This module will be added to the model
module HoboSerenity

  # We include this in order to use "number_to_currency" in the ODT template
  include ActionView::Helpers::NumberHelper

  def create_document(document_path, template_name, delete_odt=false, create_pdf=true)
    # document_path: where do you want to store redered template once parsed.
    # template_name: which template do you want to be rendered.

    # Here we prepare "document_folder" based on the two previous variables
    document_folder = document_path.split('/')[0...-1].join('/')
      
    # if "document_folder" doesn't exist, create it
    unless File.exist?(document_folder)
      FileUtils.mkdir_p(document_folder)
    end

    # Prepare the files paths
    template = ODT_TEMPLATES_PATH + template_name +'.odt'
    odt_path = document_path + '.odt'
    pdf_path = document_path + '.pdf'

    # Generate ODT with Serenity
    render_odt template, odt_path
    File.chmod(0664, odt_path)
      
    # Convert to PDF via LibreOffice 
    if create_pdf == true
      odt_to_pdf_cmd = "soffice --headless --convert-to pdf --outdir '#{[Rails.root, document_folder].join('/')}' '#{[Rails.root, odt_path].join('/')}' &>>#{[Rails.root,'log',Rails.env + ".log"].join('/')}"
      `#{odt_to_pdf_cmd}` # In order to avoid race condition trouble, use backticks instead system.
    end

    # By default we delete the ODT
    File.delete(odt_path) if delete_odt == true
  end
    
  # These are the paths that the download link will use
  def odt_download_url(document)
    return ["/",self.class.to_s.downcase.pluralize,"/download_odt/",id.to_s,'?h=',rand.to_s,'&document=',document].join
  end

  def pdf_download_url(document)
    return ["/",self.class.to_s.downcase.pluralize,"/download_pdf/",id.to_s,'?h=',rand.to_s,'&document=',document].join
  end

end

# This additional module will be added to the controller to handle downloads
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
    send_file document_path + '.odt', :type =>  "application/vnd.oasis.opendocument.text"
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
    send_file document_path + '.pdf', :type =>  "application/pdf"
  end 

end
