class CalculatorVC < UIViewController
  attr_accessor :delegate
  
  def viewDidLoad
    testButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    testButton.frame = [[0, 0], [150, 60]]
    testButton.center = view.center
    testButton.setTitle("Hide", forState:UIControlStateNormal)
    testButton.addTarget(self, action:'actionTapped', forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(testButton)
  end
  
  def actionTapped
     delegate.dismissViewControllerAnimated(true, completion:lambda {}) 
  end
  
end