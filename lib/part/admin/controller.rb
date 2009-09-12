require "part/admin/skin"
require "part/admin/helper"

require "raw/view/table"
require "raw/view/pager"

# The main Controller for the Admin part.

class AdminController

  include TableHelper, PagerHelper, AdminHelper

  ann :self, :element_namespace => AdminSkin

  def self.setup_template_dir_stack(stack)
    super
    stack << File.join(File.dirname(__FILE__),  "template")
  end

  def index
  end
  ann :index, :title => "Admin", :parent_controller => "/"    

end
