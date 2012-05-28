class StackImageView < UIScrollView
  def initWithFrame(aFrame)
    if super
      @backgroundImage = UIImageView.alloc.initWithImage(UIImage.imageNamed("tuinhuis.jpg"))
      @backgroundImage.frame.size = [320, 480]
      self.addSubview(@backgroundImage)
      self.contentSize = @backgroundImage.frame.size
      self.scrollEnabled = true
      self.minimumZoomScale = 0.5;
      self.maximumZoomScale = 3;
      self.zoomScale = 0.5
      self.delegate = self
    end
    self
  end
  
  def applyFilter 
    filter = CIFilter.filterWithName("CIBloom")
    filter.setDefaults
    
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