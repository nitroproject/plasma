
# Add this helper to your Controllers for upload file support.

module Uploads

  # The directory where uploaded files are stored. Typically 
  # this is a symlink to another directory outside of the 
  # webapp dir for easier updates.
  
  setting :upload_dir, :default => "uploads", :doc => "The directory where upload files are stored"
  
  # Override files by default?
  
  setting :override_files, :default => true, :doc => "Override files by default?"
  
  # Handle the file upload. Typically copies or save the file
  # to its final destination.
  
  def handle_uploaded_file(upload, upload_dir)
    real_path = File.join(
      Context.current.application.public_dir, 
      uploaded_file_path(upload_dir, upload.original_filename)
    )
    
    unless Uploads.override_files
      raise "File exists" if File.exists?(real_path)
    end
    
    FileUtils.mkdir_p(File.dirname(real_path)) rescue nil
   
    if upload.path
      FileUtils.cp(upload.path, real_path)
    else
      # gmosx FIXME: this is a hack!!
      upload.rewind
      File.open(real_path, "wb") { |f| f << upload.read }
    end
    
    FileUtils.chmod(0664, real_path)
  end

  # Return the real path of the uploaded_file. This is the 
  # path were the upload will finaly reside.
  
  def uploaded_file_path(dir, filename)
    File.join(dir, sanitize_filename(filename))
  end

  # Sanitize a filename. You can override this method to make 
  # it suit your needs.
  
  def sanitize_filename(filename)
    ext = File.extname(filename)
    base = File.basename(filename.gsub(/\\/, '/'), ext).gsub(/[\\\/\? !@$\(\)]/, '-')[0..64]
    return "#{base}#{ext}"
  end
  
end
