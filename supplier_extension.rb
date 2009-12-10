# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class SupplierExtension < Spree::Extension
  version "0.1"
  description "Describe your extension here"
  url "Adds the ability to set a supplier for individual products."

  # Please use supplier/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate
    
    Admin::BaseController.class_eval do
      before_filter :add_product_supplier_tab, :add_suppliers_tab

      def add_suppliers_tab
        @order_admin_tabs << {:name => t('suppliers'), :url => "line_items_admin_order_suppliers_url"}
      end
      
      def add_product_supplier_tab
        @product_admin_tabs << {:name => t('suppliers'), :url => "selected_admin_product_suppliers_url"}
      end
    end
    
    Admin::ConfigurationsController.class_eval do
      before_filter :add_suppliers_link, :only => :index
 
      def add_suppliers_link
        @extension_links << {:link => admin_suppliers_url, :link_text => t('suppliers'), :description => t('suppliers_description')}
      end
    end
    
    Product.class_eval do
      belongs_to :supplier
    end
    
    State.class_eval do
      has_many :suppliers
    end

  end
end
