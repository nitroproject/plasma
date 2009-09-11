require "RMagick"

# Javascript Image Cropper.

class ImageCropper

  attr_accessor :uri, :furi
  
  def initialize(options = {})
    @uri = options["uri"]
    @furi = options["furi"]
    @fwidth = (options["fwidth"] || 64).to_i
    @fheight = (options["fheight"] || 64).to_i
    @ratio = @fheight.to_f / @fwidth
    @root_dir = (options["root_dir"] || "public")
    @scale = options["scale"]
    
    unless @owidth
      w, h = get_dimensions()
      @owidth = w
      @oheight = h
    end    

    @cleft = (options["cleft"] || 0).to_i
    @ctop = (options["ctop"] || 0).to_i
    @cwidth = (options["cwidth"] || @fwidth).to_i
    @cheight = (options["cheight"] || @fheight).to_i
  end
  
  def script
    %{
    $("#cropper").Resizable(
    	{
    		minWidth: #@fwidth,
    		minHeight: #@fheight,
    		maxWidth: #@owidth,
    		maxHeight: #@oheight,
    		minTop: 0.1,
    		minLeft: 0.1,
    		maxRight: #@owidth,
    		maxBottom: #@oheight,
    		ratio: #@ratio,
    		dragHandle: true,
    		onDrag: function(x, y)
    		{
    			this.style.backgroundPosition = '-' + x + 'px -' + y + 'px';
    		},
    		handlers: {
    			se: "#resizeSE",
    			e: "#resizeE",
    			ne: "#resizeNE",
    			n: "#resizeN",
    			nw: "#resizeNW",
    			w: "#resizeW",
    			sw: "#resizeSW",
    			s: "#resizeS"
    		},
    		onResize : function(size, position) {
    			this.style.backgroundPosition = '-' + position.left + 'px -' + position.top + 'px';
    		}
    	}
    )
    }
  end

  def style
    %{
    <style>
    #cropper {
    	position: relative;
    	width: #{@fwidth}px;
    	height: #{@fheight}px;
    	cursor: move;
    	background-image: url("/#@uri");
    	background-repeat: no-repeat;
    }

    #resizeSE,
    #resizeE,
    #resizeNE,
    #resizeN,
    #resizeNW,
    #resizeW,
    #resizeSW,
    #resizeS {
    	position: absolute;
    	width: 8px;
    	height: 8px;
    	background-color: #333;
    	border: 1px solid #fff;
    	overflow: hidden;
    }

    #resizeSE {
    	bottom: -10px;
    	right: -10px;
    	cursor: se-resize;
    }

    #resizeE {
    	top: 50%;
    	right: -10px;
    	margin-top: -5px;
    	cursor: e-resize;
    }

    #resizeNE {
    	top: -10px;
    	right: -10px;
    	cursor: ne-resize;
    }

    #resizeN {
    	top: -10px;
    	left: 50%;
    	margin-left: -5px;
    	cursor: n-resize;
    }

    #resizeNW {
    	top: -10px;
    	left: -10px;
    	cursor: nw-resize;
    }

    #resizeW {
    	top: 50%;
    	left: -10px;
    	margin-top: -5px;
    	cursor: w-resize;
    }

    #resizeSW {
    	left: -10px;
    	bottom: -10px;
    	cursor: sw-resize;
    }

    #resizeS {
    	bottom: -10px;
    	left: 50%;
    	margin-left: -5px;
    	cursor: s-resize;
    }

    #cropper_container {
    	width: #{@owidth}px;
    	height: #{@oheight}px;
    	background-color: #ccc;
      background-image: url("/#@uri");
    }

    #cropper_filter {
    	float: left;
    	width: #{@owidth}px;
    	height: #{@oheight}px;
      background: #000;
      opacity: 0.6;
    }
    </style>
    }
  end
  alias_method :css, :style
    
  def container
    %{
    <div id="cropper_container">
    <div id="cropper_filter"></div>
    <div id="cropper">
    	<div id="resizeSE"></div>
    	<div id="resizeE"></div>
    	<div id="resizeNE"></div>
    	<div id="resizeN"></div>
    	<div id="resizeNW"></div>
    	<div id="resizeW"></div>
    	<div id="resizeSW"></div>
    	<div id="resizeS"></div>
    </div>
    </div>
    }
  end

  # :section: Image retouching

  def get_image
    Magick::ImageList.new(File.join(@root_dir, @uri)).first
  end
  
  def get_dimensions
    img = get_image()
    return img.columns, img.rows   
  end
  
  def crop!
    img = get_image()
    img.crop!(@cleft, @ctop, @cwidth, @cheight)
    img.scale!(@fwidth, @fheight) if @scale
    img.write(File.join(@root_dir, @furi))
  end

end

# An image cropper helper. Add this to your controllers to 
# easily support image cropping.

module ImageCropperHelper
end

