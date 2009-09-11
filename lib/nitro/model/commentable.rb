
# Add this mixin to your model to make it commentable. Generates
# a custom Comment class, Comment controller and everything 
# else.

module Commentable

  def self.included(base)
    generate_comment_class(base)
    generate_comment_controller(base)
    base.has_many(:comments, base::Comment)
  end
  
  # Generate the comment class.
  
  def self.generate_comment_class(base)
    sbase = base.name.demodulize.underscore
    
    code = %{
class Comment < ::Comment
  
  belongs_to :#{sbase}

  # Make ATOM friendly.
  
  def title
    "Comment on '\#{#{sbase}}'"
  end
  
private

  include Sweeper
    
  def sweep_affected(action = :all)
    expire_output(self) unless action == :insert
    expire_output(#{base})
    expire_output(#{sbase})
  end
  
end    
    }
    
    base.module_eval(code)
  end

  # Generate the comment controller.
  
  def self.generate_comment_controller(base)
    sbase = base.name.demodulize.underscore
    
    code = %{
class Comment::Controller

  include CAPTCHA

  before :create, :update, :delete, :call => :ensure_user
  
  def index
  end
  
  def list(parent_oid)
    if @#{sbase} = #{base}[parent_oid]
      @comments = @models = @#{sbase}.comments
    end
  end
  
  def create
    if request.post?
      @comment = request.assign(#{base}::Comment.new)
      save
      redirect_to_referer    
    end
  end
  
  def delete(oid)
    #{base}::Comment.delete(oid) if delete?(#{base}::Comment)
    redirect_to_referer
  end
  
private
  
  def save    
    @comment.user_oid = User.current_user.oid

    if captcha_valid?
      @comment.save
    else
      @comment.validation_errors = { :captcha => "Invalid captcha" }
    end
    
    redirect_to_referer
  rescue ValidationError
    flash_error @comment.validation_errors
    redirect_to_referer    
  end
    
end    
    }
    
    base.module_eval(code)  
  end

end
