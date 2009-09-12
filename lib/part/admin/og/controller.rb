require "cgi"

require "part/admin/skin"
require "part/admin/helper"

require "raw/view/table"
require "raw/view/pager"
require "raw/view/form"

#--
# Some helper methods. Also used by the extended enchanting
# code.
#++

module OgAdminHelper

private

  def class_to_name(klass)
    klass.to_s.gsub(/::/, '-')
  end
  
  def name_to_class(name)
    constant(CGI.unescape(name.gsub(/-/, '::')))
  end
  
end

# The Controller for the OgBrowser Admin module.

class OgAdminController

  include TableHelper, PagerHelper, FormHelper, AdminHelper, OgAdminHelper

  ann :self, :element_namespace => AdminSkin

  def self.setup_template_dir_stack(stack)
    super
    stack << File.join(File.dirname(__FILE__),  'template')
  end  

  def index
    @classes = Og.manager.managed_classes.sort { |x, y| x.name <=> y.name }
  end
  ann :index, :title => 'Og', :parent_controller => AdminController
  
  def list(name)
    @klass = name_to_class(name)
    @objects, @pager = paginate(@klass, :per_page => AdminPart.per_page)
  end
  ann :list, :title => 'List', :parent => :index

  def search(name)
    @klass = name_to_class(name)
    @obj = @klass.allocate
  end
  ann :search, :title => 'Search', :parent => :list
  
  def search_results
    @klass = name_to_class(request.params.delete('object_class_name').to_s)
    @objects, @pager = paginate(@klass.query_by_example(request.params), :per_page => AdminPart.per_page)
  end
  ann :search_results, :template => :list
  ann :search_results, :title => 'Results', :parent => :search
  
  def delete_class(name)
    name_to_class(name).delete_all
    redirect_to_referer
  end
  
  def destroy_class(name)
    name_to_class(name).destroy
    redirect_to_referer
  end

  def create(name)
    klass = name_to_class(name)
    @obj = klass.allocate
  end
  ann :create, :template => :update
  ann :create, :title => 'Create', :parent => :index

  def read(name, oid)
  end
    
  def update(name, oid)
    klass = name_to_class(name)
    @obj = klass[oid]
  end
  ann :update, :title => 'Update', :parent => :index

  def save
    klass = name_to_class(request['object_class_name'].to_s)

    if oid = request['oid']
      obj = klass[oid.to_s]
      obj.assign(request, :assign_relations => true, :force_boolean => true)
    else
      obj = klass.new
      obj.assign(request, :assign_relations => true)
    end

    obj.save
    redirect :list, :name, obj.class

  rescue ValidationError => ex
    flash.concat :ERRORS, ex.errors
    redirect_to_referer
  end  

  def delete(name, oid)
    klass = name_to_class(name)
    klass.delete(oid)
    redirect_to_referer
  end

end
