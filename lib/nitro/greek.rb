# Support for greek sites. Require this file at the end
# of your initialization script.

require "nitro/greek/greeklish"
require "nitro/greek/time"

require "nitro/greek/webfile" if defined? Glue::WebFile
require "nitro/greek/seo" # if defined? SEO

require "glue/greek/content" if defined? NamedContent

