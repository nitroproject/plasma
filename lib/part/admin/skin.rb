module AdminSkin

class Page

  def head
    %~
    <head>
      <title>Nitro Administration</title>
      <meta name="generator" content="nitro" />
      <meta name="title" content="Nitro Administration" /> 
      <meta name="description" content="Nitro Administration" />
      <meta name="category" content="portal" />
      <meta name="robots" content="index, nofollow" />
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      #{css}
    </head>
    ~
  end
  
  def css
    %~
    <style>
      label {
        font-weight: bold;
        display: block;
      }

      img {
        border: none;
      }

      input {
        border: 1px solid #ccc;
        font-size: 12px;
        background: #fff;
        padding: 2px;
      }

      textarea {
        border: 1px solid #ccc;
        background: #fff;
        padding: 2px;
      }

      input:hover, textarea:hover {
        border: 1px solid #999;
      }

      input:focus, textarea:focus {
        border: 1px solid #f00;
      }

      input.button {
        color: #fff;
        background: #999;
        border: 1px solid #999;
        font-weight: bold;  
      }

      input.button:hover {
        background: #f00;
        border: 1px solid #f00;
      }

      select {
        border: 1px solid #ccc;
      }

      a:hover {
        color: #f00;
      }
      
      /* --- forms --- */

      form dl {
        width: 100%;
        margin: 0px;
      }

      form dt {
        display: block;
        margin: 0px;
        margin-right: 10px;
        padding-bottom: 10px;
        font-weight: bold;
      }

      form dd {
        display: block;  
        margin: 0px;
        padding-bottom: 10px;
      }

      /* --- tables ---*/
      
      table.data {
        border-collapse: collapse;
      }

      .data th {
        border-bottom: 1px solid #ccc;
        background: #eee;
        font-weight: bold;
        text-align: left;
        padding: 5px;
      }

      .data td {
        border-bottom: 1px solid #ccc;
        padding: 5px;
      }

      /* --- pager --- */
            
      .pager {
        margin-top: 40px; margin-bottom: 50px;
        border-top: 1px solid #ccc;
        background-color: #f0f0f0;
      }

      .pager .first {
        float: left;  
        padding: 5px;
      }

      .pager .previous {
        float: left;
        padding: 5px;
        margin-left: 5px;
      }

      .pager .next {
        float: right;  
        padding: 5px;
        margin-right: 5px;
      }

      .pager .last {
        float: right;
        padding: 5px;
      }

      .pager ul {
        float: left;
        margin: 0px;
        padding: 0px;
      }

      .pager li {
        float: left;
        display: inline;
        padding: 5px;
        padding-left: 10px;
        padding-right: 10px;
        background: none;
      }

      .pager li.active {
        background-color: #ffa;
      }

      .noitems {
        padding: 5px;
        text-align: center;
      }      
    </style>
    ~    
  end

  def footer
    %~
    <br /><br />
    Powered by <strong><a href="http://www.nitroproject.org" target="_blank">Nitro</a></strong>.
    ~
  end
  
  def render
    %~
    <html>
      #{head}
      <body>
        #{content}
        #{footer}
      </body>
    </html>
    ~
  end
end

class SitePath
  def render
    %~
      <h1>#{content}</h1>
      <br /><br />
    ~
  end
end

end
