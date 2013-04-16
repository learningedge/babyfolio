class Admin::CustomFieldsController < Admin::ApplicationController
  def index
    if params[:see_all]
      @custom_fields = CustomField.paginate :all, :page => params[:page], :per_page => 1000000, :order => params[:sort]
    else
      @custom_fields = CustomField.paginate :page => params[:page], :order => params[:sort], :per_page => 20
    end
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

end
