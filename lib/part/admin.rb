require "part/admin/skin"
require "part/admin/controller"
require "part/admin/og/controller"

# A admin management part.

class AdminPart < Nitro::Part

  # Items per page in the admin screens.

  setting :per_page, :default => 20, :doc => "Items per page in the admin screens"

  def initialize(app)
    app.dispatcher.root.admin = AdminController
    app.dispatcher.root.admin.og = OgAdminController
  end

end

