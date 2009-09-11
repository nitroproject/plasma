
# A collection of helpers to display Sitemap related 
# informantion.

module SitemapHelper

private

  def site_path_linked(postfix = nil)
    path = []
    
    act = root = @action
    ctl = self.class

    while (act && ctl) do
      anno = ctl.ann(act)

      uri = anno[:uri] || ctl.new(context).send(:encode_url, act)
      uri = "/" if uri == "" # FIXME: this shouldn't be needed!
      
      title = anno[:title] || act.to_s.humanize
      
      
      path.unshift %{<a href="#{uri}">#{title}</a>}
      
      if act == :index      
        ctl = ctl.ann(:self, :parent)
      else
        act = anno[:parent] || :index      
      end      
    end
    
    return path.join(" / ")
  end
    
end


__END__

#{site_path_linked "Viewing #{obj.title}"}
