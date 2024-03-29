class StackImageView < UIScrollView
  attr_accessor :tap_delegate
  
  DefaultColor =  "falu_rod"
  
  Layers = [
    ["deur",        [[185, 180], [32, 135]]],
    ["deurkozijn",  [[181, 172], [41, 147]]],
    ["hoekprofiel", [[85, 157], [438, 170]]],
    ["muren",       [[88, 39], [428, 286]]],
    ["ramen",       [[98, 164], [379, 108]]],
    ["windveer",    [[284, 13], [272, 178]]]
  ]
  def initWithFrame(aFrame)    
    if super
      @layers = []
      @highlightedElement = 0
      
      @layeredImage = UIView.alloc.init
      backgroundImage = UIImageView.alloc.initWithImage(UIImage.imageNamed("layers/background.png"))      
      @layeredImage.frame = backgroundImage.frame
      @layeredImage.addSubview(backgroundImage)
      
      self.addSubview(@layeredImage)
      self.contentSize = @layeredImage.frame.size
      self.scrollEnabled = true
      self.minimumZoomScale = 0.6;
      self.maximumZoomScale = 3;
      self.delegate = self
      
      # Gesture recognizers
      @tapRecognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action:"tapRecognized:")
      self.addGestureRecognizer(@tapRecognizer)
      
      self.makeLayers
    end
    self
  end
  
  def getImage
    @layeredImage.image
  end
    
  def tapRecognized(obj)    
    (0...Layers.length).each do |index|
      if @layers[index].inView?(obj.locationInView(@layers[index])) && @layers[index].pointOpaque?(obj.locationInView(@layers[index]))
        tap_delegate.toggleAnimation
        tap_delegate.currentlyEditing = MFEditingLayer
        @highlightedElement = index
        break
      end    
    end
  end
    
  def makeLayers
    Layers.each do |(layer, frame)|
      layerView = StackLayer.alloc.initWithFrame(frame)
      layerView.image = UIImage.imageNamed("layers/#{layer}/#{layer}_#{DefaultColor}.png")
      layerView.contentMode = UIViewContentModeScaleToFill
      @layeredImage.addSubview(layerView)
      @layers << layerView
    end
  end
  
  def switchColor(suffix)
    layer_name = Layers[@highlightedElement][0]
    if not (@layers[@highlightedElement].image = UIImage.imageNamed("layers/#{layer_name}/#{layer_name}_#{suffix}.png"))
      @layers[@highlightedElement].image = UIImage.imageNamed("layers/#{layer_name}/#{layer_name}_#{DefaultColor}.png")
    end
  end
  
  def switchColorForGroup(group, suffix)
    indices = []
    
    case group
    when MFGroupWall
      indices += [ 3 ]
    when MFGroupOther
      indices += [ 0, 1, 2, 4, 5 ]
    end
    
    indices.each do |i|
      layer_name = Layers[i][0]
      if not (@layers[i].image = UIImage.imageNamed("layers/#{layer_name}/#{layer_name}_#{suffix}.png"))
        puts "Missing image: layers/#{layer_name}/#{layer_name}_#{suffix}.png"
        @layers[i].image = UIImage.imageNamed("layers/#{layer_name}/#{layer_name}_#{DefaultColor}.png")
      end
    end
  end

  # UIScrollViewDelegate
  def scrollViewDidZoom(scrollView)
    subview = scrollView.subviews.objectAtIndex 0
    
    offX = if(scrollView.bounds.size.width > scrollView.contentSize.width)
           then 0.5 * (scrollView.bounds.size.width - scrollView.contentSize.width) 
           else 0.0
           end
    offY = if(scrollView.bounds.size.height > scrollView.contentSize.height)
          then 0.5 * (scrollView.bounds.size.height - scrollView.contentSize.height) 
          else 0.0
          end
          
    subview.center = [ scrollView.contentSize.width * 0.5 + offX, 
                     scrollView.contentSize.height * 0.5 + offY]
  end
  
  def viewForZoomingInScrollView(scrollView) 
      @layeredImage
  end
end

class UIView
  def inView?(point)
    if point.x < 0 || point.y < 0 || point.x > frame.size.width || point.y > frame.size.height
      return false
    end
    true
  end
  
  def image
    UIGraphicsBeginImageContext(bounds.size);

    layer.renderInContext(UIGraphicsGetCurrentContext())
    viewImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    viewImage
  end
end

class StackLayer < UIImageView
  # generate transparency map
  # make a hit test
  def pointOpaque?(point)
    pixelPtr = Pointer.new(:uchar)
    
    context = CGBitmapContextCreate(pixelPtr, 1, 1, 8, 1, nil, KCGImageAlphaOnly)
    UIGraphicsPushContext(context);
    self.image.drawAtPoint([-point.x, -point.y])
    UIGraphicsPopContext()
    CGContextRelease(context)
    
    pixel = pixelPtr[0]
                
    alpha = pixel/255.0
    transparent = alpha < 0.01
    
    if transparent 
        return false
    end
    
    true
  end
end