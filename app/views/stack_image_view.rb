class StackImageView < UIScrollView
  attr_accessor :tap_delegate
  
  DefaultColor =  "falu_rod"
  
  Layers = [
    ["deur",        [[185, 180], [32, 135]]],
    ["deurkozijn",  [[181, 172], [41, 147]]],
    ["hoekprofiel", [[85, 137], [457, 181]]],
    ["muren",       [[85, 37], [436, 292]]],
    ["ramen",       [[97, 164], [379, 108]]],
    ["windveer",    [[280, 20], [272, 178]]]
  ] 
  
  def initWithFrame(aFrame)
    if super
      @layers = []
      
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
    index = 3
    
    if @layers[index].inView?(obj.locationInView(@layers[index])) && @layers[index].pointOpaque?(obj.locationInView(@layers[index]))
      tap_delegate.toggleAnimation
      @highlightedElement = index
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

  # UIScrollViewDelegate
  def scrollViewDidZoom(scrollView)
    
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
    true
  end
end