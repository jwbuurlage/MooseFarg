class InstructionsVC < UIViewController

attr_accessor :delegate

def init
  super
  self.setModalTransitionStyle UIModalTransitionStyleFlipHorizontal
end

def viewDidLoad
  view.backgroundColor = UIColor.blackColor
  
  @stepImageView = UIImageView.alloc.initWithImage(UIImage.imageNamed("help.png"))
  @stepTextView = UITextView.alloc.initWithFrame([[0, 70], [320, 40]])
  
  titleView = UITextView.alloc.initWithFrame([[60, 20], [200, 60]])
  titleView.editable = false
  titleView.backgroundColor = nil
  titleView.font = UIFont.boldSystemFontOfSize(24.0)
  titleView.textColor = UIColor.whiteColor
  titleView.text = "Instructies"
  titleView.textAlignment = UITextAlignmentCenter
  view.addSubview(titleView)
  
  @stepView = UITextView.alloc.initWithFrame([[60, 417], [200, 60]])
  @stepView.editable = false
  @stepView.backgroundColor = nil
  @stepView.font = UIFont.boldSystemFontOfSize(16.0)
  @stepView.textColor = UIColor.whiteColor
  @stepView.text = "0/1"
  @stepView.textAlignment = UITextAlignmentCenter
  view.addSubview(@stepView)
  
  prevButton = UIButton.buttonWithType(UIButtonTypeCustom)
  prevButton.frame = [[10, 415], [40, 40]]
  prevButton.setImage(UIImage.imageNamed("prev.png"), forState:UIControlStateNormal)
  prevButton.addTarget(self, action:'prevStep', forControlEvents:UIControlEventTouchUpInside)
  view.addSubview(prevButton)
  
  nextButton = UIButton.buttonWithType(UIButtonTypeCustom)
  nextButton.frame = [[270, 415], [40, 40]]
  nextButton.setImage(UIImage.imageNamed("next.png"), forState:UIControlStateNormal)
  nextButton.addTarget(self, action:'nextStep', forControlEvents:UIControlEventTouchUpInside)
  view.addSubview(nextButton)
  
  @stepImageView.frame = [[0, 70], [320, 340]]
  view.addSubview(@stepImageView)
  
  @stepTextView.editable = false
  @stepTextView.backgroundColor = UIColor.colorWithRed(0.0, green:0.0, blue:0.0, alpha:0.5)
  @stepTextView.font = UIFont.boldSystemFontOfSize(12.0)
  @stepTextView.textColor = UIColor.whiteColor
  @stepTextView.text = "Lorem ipsum doler sit amet"
  @stepTextView.textAlignment = UITextAlignmentCenter
  view.addSubview(@stepTextView)
  
  @currentStep = 0
  self.goTo(0)
end

def steps=(steps)
  @steps = steps
end

def goTo(to)
  if(to < 0)
    reset
    return
  end
    
  if (to >= @steps.length)
    reset
    return
  end
  
  @stepImageView.image = UIImage.imageNamed("instructions/#{@steps[to].image}.png")
  @stepTextView.text = @steps[to].text
  
  @currentStep = to
  self.updateStepCounter
end

def reset
  delegate.dismissViewControllerAnimated(true, completion:lambda { @currentStep = 0; self.goTo 0; })
end

def updateStepCounter
  @stepView.text = "#{@currentStep + 1}/#{@steps.length}"
end

def prevStep
  self.goTo(@currentStep - 1)
end

def nextStep
  self.goTo(@currentStep + 1)
end

end

class Step
  attr_accessor :image #text name
  attr_accessor :text
  
  def initialize(theImage, theText)
    @image = theImage
    @text = theText
  end
end