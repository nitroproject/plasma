# System administration.

require "part/system/controller"
require "part/system/controller/og"
require "part/system/skin"

# The System part.

class SystemPart < Nitro::Part

  def initialize(app)
    app.dispatcher.root.system = SystemController
    app.dispatcher.root.system.og = OgSystemController
  end  

  def self.install(dir)
    src = File.join(File.dirname(__FILE__), "system", "template")  
    dst = File.join(dir, "template", "system")
    puts "cp -R #{src} #{dst}"

    src = File.join(File.dirname(__FILE__), "system", "public")  
    dst = File.join(dir, "public")
    puts "cp -R #{src} #{dst}"
  end

  def self.uninstall(dir)
  end
  
end

