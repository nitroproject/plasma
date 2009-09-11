require 'facets/paramix'

module Glue

# Add this Mixin to objects that participate in Sequences
# to provide previous/next functionality.
#--
# TODO: add test case.
# FIXME: remove unloads!
#++

module Sequential

  def self.included_with_parameters base, options
    parent_attr = options.fetch(:parent, 'parent')
    children_attr = options.fetch(:children, base.to_s.underscore.pluralize)
    order_attr = options.fetch(:order, 'oid')
  
    base.module_eval %{
      def first_in_sequence
      end
      
      def previous_in_sequence
        #{parent_attr}.#{children_attr}.unload
        #{parent_attr}.#{children_attr}(:condition => "#{order_attr} < \#{#{order_attr}}", :order => '#{order_attr} DESC', :limit => 1).first
      end
      
      def next_in_sequence
        #{parent_attr}.#{children_attr}.unload
        #{parent_attr}.#{children_attr}(:condition => "#{order_attr} > \#{#{order_attr}}", :order => '#{order_attr} ASC', :limit => 1).first
      end
      
      def last_in_sequence
      end    
    }
  end

end

end
