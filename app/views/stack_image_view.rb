class StackImageView < UIScrollView
  attr_accessor :tap_delegate
  
  DefaultColor =  "falu_rod"
  
  Layers = [
    ["deur",        [[185, 180], [32, 135]]],
    ["deurkozijn",  [[181, 172], [41, 147]]],
    ["hoekprofiel", [[0, 0], [100, 10]]],
    ["muren",       [[85, 37], [436, 292]]],
    ["ramen",       [[97, 164], [379, 108]]],
    ["windveer",    [[0, 0], [100, 100]]]
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
    
  def tapRecognized(obj)    
    if @layers[0].inView?(obj.locationInView(@layers[0]))
      tap_delegate.toggleAnimation
      @highlightedElement = 0
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
end

class StackLayer < UIImageView

end