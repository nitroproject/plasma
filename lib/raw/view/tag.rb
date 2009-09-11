require 'cgi'

# Add this helper to your controllers to add tag related 
# functionality.

module TagHelper

  def self.included_with_parameters base, params
    unless klass = params[:class]
      raise "Required parameter ':class' not provided!"
    end

    base.module_eval %{
      def tag_#{klass.name.demodulize.underscore}
        if obj = #{klass}[request['oid']]
          obj.tag(CGI.unescape(request['tag_string'].to_s))
        end
        redirect_to_referer
      end      
    }
  end
  
end
