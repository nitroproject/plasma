# A Helper for sitemap handling.
#
# Use annotations to provide titles for actions.
# Use @sitenode_title to provide a dynamic title for
# an action.
#
# === Options
#
# * :title => the title of the action
# * :uri => the uri of the action (if not provided the action name is used)
# * :parent => the parent action 
# * :parent_controller => the parent controller (accepts class or mount path)
#
# === Examples
#
# def my_action
# ..
# end
# ann :my_action, :title => 'The title', :uri => :my_action, :parent => :another_action
#--
# TODO: Humanize the action name to get the title.
# TODO: cache sitemap generation.
# TODO: refactor a bit
# TODO: leverage controller hierarchy information.
#++

module SitemapHelper
  # The sitepath separator.
  
  setting :separator, :default => ' / ', :doc => 'The sitepath separator'

  # Returns the title for the current page.
=begin  
  def page_title
    self.class.ann(@action_name.to_sym).title
  end
=end  
  # Returns the sitepath for the current action.
  # The generated sitepath is cached as an annotation.
  # If the action defines a variable @sitepath the helper
  # uses it to build the final sitepath. The @sitepath
  # variable can be a single object or an array of objects (the
  # array defines a path).
  # If the action defines a variable @sitepath_postfix this
  # is appended to the sitepath.
  # If an optional postfix is provided it is appended to the
  # sitepath.
  
  def sitepath(postfix = nil)
    act = root = @action_name
    ctl = self.class

    spath = []
    
    if @sitepath
      @sitepath = [ @sitepath ] unless @sitepath.is_a?(Array)
      @sitepath.each do |node|
        spath << node.to_s
      end
    end
        
    while act do
      anno = ctl.ann(act.to_sym)
      
      if act == root
        spath << @sitepath_postfix if @sitepath_postfix
        spath << anno[:title] if anno[:title]
      else
        spath << anno[:title] if anno[:title]
      end
      
      if act.to_sym == :index      
        act = anno[:parent]      
      else
        act = anno[:parent] || :index      
      end
            
      if pctl = anno[:parent_controller]
        ctl = pctl.is_a?(Class) ? pctl : Context.current.dispatcher[pctl.to_s]
        act ||= :index
      end
    end

    return "#{spath.reverse.join(SitemapHelper.separator)}#{postfix}"
  end
  
  # Returns the linked sitepath for the current action.
  # If the action defines a variable @sitepath the helper
  # uses it to build the final sitepath. The @sitepath
  # variable can be a single object or an array of objects (the
  # array defines a path).
  # If the action defines a variable @sitepath_postfix this
  # is appended to the sitepath.
  # If an optional postfix is provided it is appended to the
  # sitepath.
  #
  # If no uri is explicitly defined in the annotation,
  # the action name is used instead.
  
  def sitepath_linked(postfix = nil)
    act = root = @action_name
    ctl = self.class
    
    spath = []

    if @sitepath
      @sitepath = [ @sitepath ] unless @sitepath.is_a?(Array)
      @sitepath.each_with_index do |node, i|
        if i == 0 or (!node.respond_to? :to_link)
          spath << node.to_s
        else
          spath << node.to_link
        end
      end
      
      # hack: set root to something ~= act to force linking
      # the first node.
      
      root = nil
    end
        
    while act do
      anno = ctl.ann(act.to_sym)
      uri = anno[:uri] || ctl.new(context).send(:encode_url, act)
            
      if act == root
        spath << @sitepath_postfix if @sitepath_postfix
        spath << anno[:title] if anno[:title]
      else
        spath << %|<a href="#{uri}">#{anno[:title]}</a>| if anno[:title]
      end

      if act.to_sym == :index      
        act = anno[:parent]      
      else
        act = anno[:parent] || :index      
      end
      
      if pctl = anno[:parent_controller]
        ctl = pctl.is_a?(Class) ? pctl : Context.current.dispatcher[pctl.to_s]
        act ||= :index
      end
    end

    return "#{spath.reverse.join(SitemapHelper.separator)}#{postfix}"
  end
  alias navigation_bar sitepath_linked
  
end
