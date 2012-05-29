class StackImageView < UIScrollView
  attr_accessor :tap_delegate
  
  def initWithFrame(aFrame)
    if super
      @backgroundImage = UIImageView.alloc.initWithImage(UIImage.imageNamed("tuinhuis.jpg"))
      @backgroundImage.frame.size = [320, 480]
      self.addSubview(@backgroundImage)
      self.contentSize = @backgroundImage.frame.size
      self.scrollEnabled = true
      self.minimumZoomScale = 0.6;
      self.maximumZoomScale = 3;
      self.delegate = self
      
      # Gesture recognizers
      @tapRecognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action:"tapRecognized:")
      self.addGestureRecognizer(@tapRecognizer)
    end
    self
  end
    
  def tapRecognized(obj)
    puts "#{obj.locationInView(@backgroundImage).x}, #{obj.locationInView(@backgroundImage).y}"
    tap_delegate.toggleAnimation
  end
    
  def makeLayers(layers)
    layers.each do |layer|
      
    end
  end

  # UIScrollViewDelegate
  def scrollViewDidZoom(scrollView)
    
  end
  
  def viewForZoomingInScrollView(scrollView) 
      @backgroundImage
  end
end

class StackLayer < UIImageView
  def initWithImage(image)
    if super
      
    end
    self
  end
end