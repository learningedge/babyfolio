class FamiliesController < ApplicationController
  def new
    @family = Family.new
    4.times {
      @family.children.build
    }

    
  end

  def create
    @family = Family.new(params['family']);
    
    respond_to do |format|
      if @family.save
        format.html { redirect_to([@product], :notice => 'Product was successfully created.') }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else

       format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

end
