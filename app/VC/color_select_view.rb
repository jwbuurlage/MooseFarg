class ColorSelectView < UIScrollView
  attr_accessor :delegate
  
  def initWithFrame(theFrame, andColors:colors)
    if super
      self.initColorViews(colors)
      self.contentSize = [colors.length * 60 + 40, frame.size.height]
    end
    self
  end
  
  def initColorViews(colors)
    colors.each_with_index do |(color, name), i|
      colorButton = UIButton.buttonWithType(UIButtonTypeCustom)
      colorButton.backgroundColor = color
      colorButton.layer.cornerRadius = 3.0
      colorButton.addTarget(delegate, action:'colorShouldChange:', forControlEvents:UIControlEventTouchUpInside)
      colorButton.frame = [[20 + i * 60, 10], [40, 40]]
      colorButton.tag = i + 100
      self.addSubview(colorButton)
    end
  end
  
  #... intercept touches
  def touchesBegan(touches, withEvent:event)
  
  end
  
  def touchesEnded(touches, withEvent:event)
    @previousPoint = nil
  end
end
