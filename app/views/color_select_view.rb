class ColorSelectView < UIScrollView
  attr_accessor :delegate
  
  def initWithFrame(theFrame, andColors:colors)
    if super
      self.initColorViews(colors)
      self.contentSize = [colors.length * 60 + 20, frame.size.height]
    end
    self
  end
  
  def initColorViews(colors)
    colors.each_with_index do |(color, name), i|
      colorButton = UIButton.buttonWithType(UIButtonTypeCustom)
      colorButton.backgroundColor = color
      colorButton.layer.cornerRadius = 5.0
      colorButton.addTarget(delegate, action:'colorShouldChange:', forControlEvents:UIControlEventTouchUpInside)
      colorButton.frame = [[20 + i * 60, 5], [40, 40]]
      colorButton.tag = i + 100
      self.addSubview(colorButton)
    end
  end
end
