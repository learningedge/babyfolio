class UploadedImagesController < ApplicationController

  def index

    @one_image = Media.find(params[:id])
    respond_to do |format|
      format.html { render :index, :layout => false }
    end
    
  end

  def update
    
    if params[:qqfile].kind_of? String
      ext = '.' + params[:qqfile].split('.').last
      fname = params[:qqfile].split(ext).first
      tempfile = Tempfile.new([fname, ext])
      tempfile.binmode
      tempfile << request.body.read
      tempfile.rewind
    else
      tempfile = params[:qqfile].tempfile
    end

    media = MediaImage.create_media_object(tempfile, current_user.id)
    respond_to do |format|
      format.text { render :text => "{\"media_id\":\"#{media.id}\"}" }
    end
  end

  
end
