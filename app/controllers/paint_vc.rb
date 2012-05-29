class PaintVC < UIViewController
  Colors = [
    [UIColor.colorWithRed(252/255.0, green:254/255.0, blue:242/255.0, alpha:1.0) , "gradde"],
    [UIColor.colorWithRed(255/255.0, green:212/255.0, blue:72/255.0,  alpha:1.0) , "skane_gul"],
    [UIColor.colorWithRed(255/255.0, green:224/255.0, blue:130/255.0, alpha:1.0) , "ljus_gul"],
    [UIColor.colorWithRed(146/255.0, green:117/255.0, blue:103/255.0, alpha:1.0) , "mullvad_brun"],
    [UIColor.colorWithRed(132/255.0, green:18/255.0,  blue:18/255.0,  alpha:1.0) , "falu_rod"],
    [UIColor.colorWithRed(0/255.0,   green:0/255.0,   blue:0/255.0,   alpha:1.0) , "vasa_svart"], 
    [UIColor.colorWithRed(174/255.0, green:179/255.0, blue:178/255.0, alpha:1.0) , "kiruna_gra"],
    [UIColor.colorWithRed(118/255.0, green:143/255.0, blue:151/255.0, alpha:1.0) , "skiffer_gra"],
    [UIColor.colorWithRed(66/255.0,  green:87/255.0,  blue:97/255.0,  alpha:1.0) , "blytunga_svart"], 
    [UIColor.colorWithRed(118/255.0, green:189/255.0, blue:213/255.0, alpha:1.0) , "ljus_bla"],
    [UIColor.colorWithRed(0.0/255.0, green:152/255.0, blue:88/255.0,  alpha:1.0) , "dalarna_gron"],
    [UIColor.colorWithRed(54/255.0,  green:150/255.0, blue:170/255.0, alpha:1.0) , "bohus_bla"], 
    [UIColor.colorWithRed(139/255.0, green:189/255.0, blue:130/255.0, alpha:1.0) , "amal_gron"]
  ]
  
  ToggleDuration = 0.3
    
  def viewDidLoad    
    # image + bottom
    @stackImageView = StackImageView.alloc.initWithFrame([[0, 0], view.frame.size])
    @stackImageView.tap_delegate = self
    view.addSubview(@stackImageView)
    
    @bottomView = UIView.alloc.initWithFrame([[0, 400], [320, 120]])
    @bottomView.backgroundColor = UIColor.colorWithRed(0.0, green:0.0, blue:0.0, alpha: 0.8)    
    @colorSelectView = ColorSelectView.alloc.initWithFrame([[0, 60], [320, 60]], andColors:Colors)
    @colorSelectView.delegate = self
    @bottomView.addSubview(@colorSelectView)
    view.addSubview(@bottomView)
    
    @bottomViewHidden = true
    
    # buttons
    registrationButton = UIButton.buttonWithType(UIButtonTypeCustom)
    registrationButton.frame = [[20, 10], [40, 40]]
    registrationButton.setImage(UIImage.imageNamed("user.png"), forState:UIControlStateNormal)
    registrationButton.addTarget(self, action:'showRegistrationPane', forControlEvents:UIControlEventTouchUpInside)
    @bottomView.addSubview(registrationButton)
        
    calculatorButton = UIButton.buttonWithType(UIButtonTypeCustom)
    calculatorButton.frame = [[70, 10], [40, 40]]
    calculatorButton.setImage(UIImage.imageNamed("tags.png"), forState:UIControlStateNormal)
    calculatorButton.addTarget(self, action:'showCalculatorPane', forControlEvents:UIControlEventTouchUpInside)
    @bottomView.addSubview(calculatorButton)
    
    shareButton = UIButton.buttonWithType(UIButtonTypeCustom)
    shareButton.frame = [[260, 10], [40, 40]]
    shareButton.setImage(UIImage.imageNamed("share.png"), forState:UIControlStateNormal)
    shareButton.addTarget(self, action:'showActionPane', forControlEvents:UIControlEventTouchUpInside)
    @bottomView.addSubview(shareButton)
    
    # modals
    @registrationVC = RegistrationVC.alloc.initWithStyle(UITableViewStyleGrouped)
    @registrationVC.delegate = self
    @shareSheet = UIActionSheet.alloc.initWithTitle("Deel met uzelf of met uw vrienden", 
                                                    delegate:self, 
                                                    cancelButtonTitle:"Annuleer", 
                                                    destructiveButtonTitle:nil, 
                                                    otherButtonTitles:"Facebook", "Twitter", "Google +", "E-mail", nil)
    @calculatorVC = CalculatorVC.alloc.init
    @calculatorVC.delegate = self
  end
  
  def toggleAnimation        
    if @bottomViewHidden
      UIView.animateWithDuration(ToggleDuration, animations:lambda { @bottomView.frame = [[0, 340], [320, 120]] })
      @bottomViewHidden = false
    else
      UIView.animateWithDuration(ToggleDuration, animations:lambda { @bottomView.frame = [[0, 400], [320, 120]] })
      @bottomViewHidden = true
    end
  end
  
  def canBecomeFirstResponder
    true
  end
  
  def showRegistrationPane
    self.presentViewController(@registrationVC, animated:true, completion:lambda { })
  end
  
  def showCalculatorPane
    self.presentViewController(@calculatorVC, animated:true, completion:lambda { })
  end
  
  def showActionPane
    @shareSheet.showInView(view)
  end
  
  def colorShouldChange(aButton)
    # puts "color hit:"
    # puts (Colors[aButton.tag - 100])[1] 
    self.toggleAnimation
    @stackImageView.switchColor((Colors[aButton.tag - 100])[1])
  end
  
end
