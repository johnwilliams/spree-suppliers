class Admin::SuppliersController < Admin::BaseController
  resource_controller
  belongs_to :product
  before_filter :load_data, :only => [:selected, :available, :remove, :new, :edit, :select]

  def line_items
    @order = Order.find_by_number(params[:order_id])
  end
  
  def selected
    @supplier = @product.supplier
  end
  
  def available
    if params[:q].blank?
      @available_suppliers = []
    else
      @available_suppliers = Supplier.find(:all, :conditions => ['lower(name) LIKE ?', "%#{params[:q].downcase}%"])
    end
    @available_suppliers.delete_if { |supplier| @product.supplier == supplier }
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
 
  end
  
  def remove
    @product.supplier = nil
    @product.save
    @supplier = @product.supplier
    render :layout => false
  end
  
  def select
    @supplier = Supplier.find_by_param!(params[:id])
    @product.supplier = @supplier
    @product.save
    @supplier = @product.supplier
    render :layout => false
  end


  update.response do |wants|
    wants.html { redirect_to collection_url }
  end
 
  update.after do
    Rails.cache.delete('suppliers')
  end
 
  create.response do |wants|
    wants.html { redirect_to collection_url }
  end
 
  create.after do
    Rails.cache.delete('suppliers')
  end
  
  private

  def load_data
    default_country = Country.find Spree::Config[:default_country_id]
    @states = default_country.states.sort
    @product = Product.find_by_permalink(params[:product_id])
  end
 
end