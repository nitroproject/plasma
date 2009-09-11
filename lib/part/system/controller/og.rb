require "raw/view/nform"
require "part/admin/helper"

# Og administration system.

class OgSystemController
  
  include PagerHelper, Forms
  include SitemapHelper, AdminHelper

  ann :self, :element_namespace => SystemController

  def index
    @classes = Og.manager.managed_classes.sort { |x, y| x.name <=> y.name }
  end
  ann :index, :title => "Og"

  def list(class_name)
    @class_name = class_name
    @klass = name_to_class(class_name)
    options = {
      :per_page => 20
    }
    
    if @klass.instance_methods.include? "create_time"
      options[:order] = "create_time DESC"
    end
    @objects, @pager = paginate(@klass, options)
    @ui = ModelUI.for(@klass)
  end
  
  #--
  # TODO: implement
  #++
    
  def view(class_name, oid)
    @obj = load_object(class_name, oid)
    @ui = ModelUI.for(@klass)
  end

  def create(class_name)
    if @klass = name_to_class(class_name)
      @obj = @klass.new
    end
    
    if request.post?
      @obj = request.assign(@klass.new)
      @obj.save!
      redirect_to :list, :class_name, @klass
    end
  rescue ValidationError
    flash_error @obj.validation_errors
  end
  
  def update(class_name, oid)
    @obj = load_object(class_name, oid)

    if request.post?
      request.assign(@obj)
      @obj.save!
      redirect_to :list, :class_name, @obj.class
    end
  rescue ValidationError
    flash_error @obj.validation_errors
  end
  ann :update, :parent => :list

  # Delete an instance of a class.
  
  def delete(class_name, oid)
    if obj = load_object(class_name, oid)
      obj.delete # if admin?(obj)
    end
    redirect_to_referer
  end

  # Delete all instances of a class.
  
  def delete_all(class_name)
    if klass = name_to_class(class_name)
      klass.delete_all
    end
    redirect_to_referer
  end

  # Query by example.
  
  def query(class_name)
    if @klass = name_to_class(class_name)
      @obj = @klass.new
    end
    
    if request.post?
      @objects, @pager = paginate(@klass.query_by_example(request.params))
      render_template :list
    end
  end
  
  def query_results
    @class_name = request.params.delete("class_name")
    @klass = name_to_class(@class_name)
    @objects, @pager = paginate(@klass.query_by_example(request.params))
    @ui = ModelUI.for(@klass)    
  end
  ann :query_results, :template => :list
    
private

  def class_to_name(klass)
    klass.to_s.gsub(/::/, "-")
  end
  
  def name_to_class(name)
    constant(CGI.unescape(name.gsub(/-/, "::")))
  end
   
  def load_object(class_name, oid)
    if klass = name_to_class(class_name)
      if obj = klass[oid]
        return obj
      else
        flash_error "Cannot load object '#{oid}'"
      end
    else
      flash_error "Unmanaged class #{class_name}"
    end  
    
    return false
  end 
    
end
