require "raw/sitemap"
require "part/admin/helper"

# The main System controller.

class SystemController
  
  include SitemapHelper, AdminHelper

  def index
  end
  ann :index, :title => "System"
  
end

