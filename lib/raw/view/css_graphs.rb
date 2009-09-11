# = CSS Graphs
#
# Makes graphs using pure CSS.
#
# == Resources
#
# Subversion
#
# * http://topfunky.net/svn/plugins/css_graphs
#
# Blog
#
# * http://nubyonrails.com/pages/css_graphs

module CssGraphsHelper
   
  # Makes a vertical bar graph.
  #
  #  bar_graph ["Stout", 10], ["IPA", 80], ["Pale Ale", 50], ["Milkshake", 30]
  #
  def bar_graph(*data)
    if data.last.is_a? Hash
      options = data.pop
    else
      options = []
    end
      
    width = options.fetch(:width, 378)
    height = options.fetch(:height, 150)
    colors = %w(#ce494a #efba29 #efe708 #5a7dd6 #73a25a)
    floor_cutoff = 24
    
    html = <<-"HTML"
    <style>
      #vertgraph {            
          width: #{width}px; 
          height: #{height}px; 
          position: relative; 
          background-color: #eeeeee;
          border: 4px solid #999999;
          font-family: "Lucida Grande", Verdana, Arial;
      }
    
      #vertgraph dl dd {
        position: absolute;
        width: 28px;
        height: 103px;
        bottom: 34px;
        padding: 0 !important;
        margin: 0 !important;
        background-image: url('#{CssGraphsHelper.images_dir}/colorbar.jpg') no-repeat !important;
        text-align: center;
        font-weight: bold;
        color: white;
        line-height: 1.5em;
      }

      #vertgraph dl dt {
        position: absolute;
        width: 48px;
        height: 25px;
        bottom: 0px;
        padding: 0 !important;
        margin: 0 !important;
        text-align: center;
        color: #444444;
        font-size: 0.8em;
      }
    HTML

    bar_offset = 24
    bar_increment = 75
    bar_image_offset = 28
    
    data.each_with_index do |d, index|
      bar_left = bar_offset + (bar_increment * index)
      label_left = bar_left - 10
      background_offset = bar_image_offset * index
      
      html += <<-HTML
        #vertgraph dl dd.#{d[0].to_s.downcase} { left: #{bar_left}px; background-color: #{colors[index]}; background-position: -#{background_offset}px bottom !important; }
        #vertgraph dl dt.#{d[0].to_s.downcase} { left: #{label_left}px; background-position: -#{background_offset}px bottom !important; }
      HTML
    end
    
    html += <<-"HTML"
      </style>
      <div id="vertgraph">
        <dl>
    HTML
    
    data.each_with_index do |d, index|
      html += <<-"HTML"
        <dt class="#{d[0].to_s.downcase}">#{d[0].to_s.humanize}</dt>
        <dd class="#{d[0].to_s.downcase}" style="height: #{d[1]}px;" title="#{d[1]}">#{d[1] < floor_cutoff ? '' : d[1]}</dt>
      HTML
    end
        
    html += <<-"HTML"
        </dl>
      </div>
    HTML
    
    html
  end
  
  # Make a horizontal graph that only shows percentages.
  #
  # The label will be set as the title of the bar element.
  #
  #  horizontal_bar_graph ["Stout", 10], ["IPA", 80], ["Pale Ale", 50], ["Milkshake", 30]
  # 
  def horizontal_bar_graph(*data)
    html = <<-"HTML"
      <style>
      /* Basic Bar Graph */
      .graph { 
        position: relative; /* IE is dumb */
        width: 200px; 
        border: 1px solid #B1D632; 
        padding: 2px; 
        margin-bottom: .5em;          
      }
      .graph .bar { 
        display: block;  
        position: relative;
        background: #B1D632; 
        text-align: center; 
        color: #333; 
        height: 2em; 
        line-height: 2em;                  
      }
      .graph .bar span { position: absolute; left: 1em; } /* This extra markup is necessary because IE does not want to follow the rules for overflow: visible */   
      </style>
    HTML
    
    data.each do |d|
      html += <<-"HTML"
        <div class="graph">
          <strong class="bar" style="width: #{d[1]}%;" title="#{d[0].to_s.humanize}"><span>#{d[1]}%</span> </strong>
        </div>
      HTML
    end
    return html
  end
  
  # Makes a multi-colored bar graph with a bar down the middle, representing the value.
  #
  #  complex_bar_graph ["Stout", 10], ["IPA", 80], ["Pale Ale", 50], ["Milkshake", 30]
  #  
  def complex_bar_graph(*data)
    html = <<-"HTML"
      <style>
      /* Complex Bar Graph */
      div#complex_bar_graph dl { 
        margin: 0; 
        padding: 0;   
        font-family: "Lucida Grande", Verdana, Arial;  
      }
      div#complex_bar_graph dt { 
        position: relative; /* IE is dumb */
        clear: both;
        display: block; 
        float: left; 
        width: 104px; 
        height: 20px; 
        line-height: 20px;
        margin-right: 17px;              
        font-size: .75em; 
        text-align: right; 
      }
      div#complex_bar_graph dd { 
        position: relative; /* IE is dumb */
        display: block;   
        float: left;   
        width: 197px; 
        height: 20px; 
        margin: 0 0 15px; 
        background: url("#{CssGraphsHelper.images_dir}/g_colorbar.jpg"); 
      }
      * html div#complex_bar_graph dd { float: none; } /* IE is dumb; Quick IE hack, apply favorite filter methods for wider browser compatibility */
  
      div#complex_bar_graph dd div { 
        position: relative; 
        background: url("#{CssGraphsHelper.images_dir}/g_colorbar2.jpg"); 
        height: 20px; 
        width: 75%; 
        text-align:right; 
      }
      div#complex_bar_graph dd div strong { 
        position: absolute; 
        right: -5px; 
        top: -2px; 
        display: block; 
        background: url("#{CssGraphsHelper.images_dir}/g_marker.gif"); 
        height: 24px; 
        width: 9px; 
        text-align: left;
        text-indent: -9999px; 
        overflow: hidden;
      }
      </style>
      <div id="complex_bar_graph">  
      <dl>
    HTML

    data.each do |d|
      html += <<-"HTML"
        <dt class="#{d[0].to_s.downcase}">#{d[0].to_s.humanize}</dt>
        <dd class="#{d[0].to_s.downcase}" title="#{d[1]}">
        <div style="width: #{d[1]}%;"><strong>#{d[1]}%</strong></div>
      </dd>
    HTML
    end
    
    html += "</dl>\n</div>"
    return html    
  end
end

module CssGraphsHelper

  # The directory where css_graphs images reside.
  
  setting :images_dir, :default => '/m/css_graphs', :doc => 'The directory where css_graphs images reside' 
  
end
