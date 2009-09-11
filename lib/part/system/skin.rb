# The System skin.

class SystemController

class Page < Raw::Element

  def doctype
    %{
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    }
  end

  def head
    %{
    <head profile="http://gmpg.org/xfn/11">
      <title>System</title>
    	<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
    	<meta name="generator" content="Nitro" />
      <meta name="description" content="System Administration" />        
      <link href="/system/screen.css" media="screen" rel="Stylesheet" type="text/css" />
      <script src="/js/jquery.js" type="text/javascript" />
      <script src="/js/jquery-calendar.js" type="text/javascript" />
      <script src="/js/cookie.js" type="text/javascript" />      
      <script src="/js/raw.js" type="text/javascript" />
      <script src="/js/human_time_el.js" type="text/javascript" />
      <script src="/js/jqpstr.js" type="text/javascript" />
      <script src="/js/form.js" type="text/javascript" />      
      #{content :head}
    </head>
    }
  end
  
  def header
    %{
    <div id="header">
      <div id="navigation">
        \#{site_path_linked}
      </div>
    </div>
    }
  end
  
  def footer
    %{
    <div id="footer">
      Powered by <a href="http://nitroproject.org">Nitro</a>.
    </div>
    }
  end
  
  def render
    %{
    #{doctype}
    <html xmlns="http://www.w3.org/1999/xhtml">
      #{head}
      <body>
        #{header}
        <div id="container">
          #{content}
        </div>
        #{footer}
      </body>
    </html>
    }
  end
  
end

end
