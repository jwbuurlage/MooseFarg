# For colorselection
MFEditingLayer = 0
MFEditingGroup = 1

MFGroupWall = 0
MFGroupOther = 1

class PaintVC < UIViewController
  attr_accessor :currentlyEditing
  
  Colors = [
    [UIColor.colorWithRed(252/255.0, green:254/255.0, blue:242/255.0, alpha:1.0) , "gradde"],
    [UIColor.colorWithRed(255/255.0, green:212/255.0, blue:72/255.0,  alpha:1.0) , "skane_gul"],
    #[UIColor.colorWithRed(255/255.0, green:224/255.0, blue:130/255.0, alpha:1.0) , "ljus_gul"],
    [UIColor.colorWithRed(146/255.0, green:117/255.0, blue:103/255.0, alpha:1.0) , "mullvad_brun"],
    [UIColor.colorWithRed(132/255.0, green:18/255.0,  blue:18/255.0,  alpha:1.0) , "falu_rod"],
    [UIColor.colorWithRed(0/255.0,   green:0/255.0,   blue:0/255.0,   alpha:1.0) , "vasa_svart"], 
    [UIColor.colorWithRed(174/255.0, green:179/255.0, blue:178/255.0, alpha:1.0) , "kiruna_gra"],
    [UIColor.colorWithRed(118/255.0, green:143/255.0, blue:151/255.0, alpha:1.0) , "skiffer_gra"],
    [UIColor.colorWithRed(66/255.0,  green:87/255.0,  blue:97/255.0,  alpha:1.0) , "blytunga_svart"], 
    [UIColor.colorWithRed(118/255.0, green:189/255.0, blue:213/255.0, alpha:1.0) , "ljusbla"],
    [UIColor.colorWithRed(0.0/255.0, green:152/255.0, blue:88/255.0,  alpha:1.0) , "dalarna_gron"],
    [UIColor.colorWithRed(54/255.0,  green:150/255.0, blue:170/255.0, alpha:1.0) , "bohus_bla"], 
    [UIColor.colorWithRed(139/255.0, green:189/255.0, blue:130/255.0, alpha:1.0) , "amalgron"],
    [UIColor.colorWithRed(88/255.0,  green:126/255.0, blue:193/255.0, alpha:1.0) , "kungsbla"]
  ]
  
  ToggleDuration = 0.3
  
  # Sharing descriptions
  MailSubject = "Moose F\u00E4rg kleuren combinatie tester"
  MailFilename = "moosefarg-kleurentester"
  MailBody = "Wat vind je van deze Moose F\u00E4rg kleuren?"
  
  TwitterText = "Wat vinden jullie van deze Moose F\u00E4rg verfcombinatie? \#moosefarg"
    
  def viewDidLoad    
    @buttons ||= []
    
    w = view.frame.size.width
    h = view.frame.size.height
    
    @instrVC = InstructionsVC.alloc.init;  
    @instrVC.delegate = self
    
    # intro steps
    steps = [ 
      Step.new("kleur_element", "Selecteer een element, en geef hem een kleur. U kunt meer kleuren selecteren door te slepen."),
      Step.new("registreer", "Registreer voor de nieuwsbrief, of voeg ons toe aan uw adresboek."),
      Step.new("bereken", "Vul de oppervlakte in, en bereken hoeveel verf u nodig heeft."),
      Step.new("kleur_groepen", "U kunt ook een groep elementen tegelijk kleuren."),
      Step.new("deel", "Deel uw kleurencombinatie via E-mail of Twitter.")
    ]
    
    @instrVC.steps = steps
    
    @currentlyEditing = MFEditingLayer
    
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
    
    bw = 40 # button width
    bh = 40 # button height
    bc = 5 # button count
    bs = ((w.to_f / bc) - bw)/2.0 # button spacing
    
    # buttons
    registrationButton = UIButton.buttonWithType(UIButtonTypeCustom)
    registrationButton.frame = [[bs, 10], [bw, bh]]
    registrationButton.setImage(UIImage.imageNamed("user.png"), forState:UIControlStateNormal)
    registrationButton.addTarget(self, action:'showRegistrationPane', forControlEvents:UIControlEventTouchUpInside)
    @bottomView.addSubview(registrationButton)
        
    calculatorButton = UIButton.buttonWithType(UIButtonTypeCustom)
    calculatorButton.frame = [[w/bc + bs, 10], [bw, bh]]
    calculatorButton.setImage(UIImage.imageNamed("pie_chart.png"), forState:UIControlStateNormal)
    calculatorButton.addTarget(self, action:'showCalculatorPane', forControlEvents:UIControlEventTouchUpInside)
    @bottomView.addSubview(calculatorButton)
    
    paintButton = UIButton.buttonWithType(UIButtonTypeCustom)
    paintButton.frame = [[2*w/bc + bs, 10], [bw, bh]]
    paintButton.setImage(UIImage.imageNamed("sampler.png"), forState:UIControlStateNormal)
    paintButton.addTarget(self, action:'showLayerGroupsPane', forControlEvents:UIControlEventTouchUpInside)
    @bottomView.addSubview(paintButton)
        
    instrButton = UIButton.buttonWithType(UIButtonTypeCustom)
    instrButton.frame = [[3*w/bc + bs, 10], [bw, bh]]
    instrButton.setImage(UIImage.imageNamed("help.png"), forState:UIControlStateNormal)
    instrButton.addTarget(self, action:'showInstrPane', forControlEvents:UIControlEventTouchUpInside)
    @bottomView.addSubview(instrButton)
    
    shareButton = UIButton.buttonWithType(UIButtonTypeCustom)
    shareButton.frame = [[4*w/bc + bs, 10], [bw, bh]]
    shareButton.setImage(UIImage.imageNamed("share.png"), forState:UIControlStateNormal)
    shareButton.addTarget(self, action:'showActionPane', forControlEvents:UIControlEventTouchUpInside)
    @bottomView.addSubview(shareButton)
    
    @buttons += [ registrationButton, calculatorButton, shareButton, instrButton, paintButton ]
    
    # modals
    @registrationVC = RegistrationVC.alloc.initWithStyle(UITableViewStyleGrouped)
    @registrationVC.delegate = self
    
    @shareSheet = UIActionSheet.alloc.initWithTitle("Deel met uzelf of met uw vrienden", 
                                                    delegate:self, 
                                                    cancelButtonTitle:"Annuleer", 
                                                    destructiveButtonTitle:nil, 
                                                    otherButtonTitles:"Twitter", "E-mail", nil)
                                                     #"Google +", "Facebook",
                                                     
    @paintSheet = UIActionSheet.alloc.initWithTitle("Geef groepen elementen dezelfde kleur", 
                                                   delegate:self, 
                                                   cancelButtonTitle:"Annuleer", 
                                                   destructiveButtonTitle:nil, 
                                                   otherButtonTitles:"Muur", "Overig", nil)
                                                     
    @calculatorVC = CalculatorVC.alloc.initWithStyle(UITableViewStyleGrouped)
    @calculatorVC.delegate = self      
  end
  
  def toggleAnimation        
    if @bottomViewHidden
      @buttons.each { |but| but.enabled = false }
      UIView.animateWithDuration(ToggleDuration, animations:lambda { @bottomView.frame = [[0, 340], [320, 120]] })
      @bottomViewHidden = false
    else
      @buttons.each { |but| but.enabled = true }
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
  
  def showInstrPane
    self.presentViewController(@instrVC, animated:true, completion:lambda { })
  end
  
  def showActionPane
    @shareSheet.showInView(view)
  end
  
  def showLayerGroupsPane
    @paintSheet.showInView(view)
  end
  
  def colorShouldChange(aButton)
    # puts "color hit:"
    # puts (Colors[aButton.tag - 100])[1] 
    self.toggleAnimation
    
    case @currentlyEditing
    when MFEditingLayer
      @stackImageView.switchColor((Colors[aButton.tag - 100])[1])
    when MFEditingGroup
      @stackImageView.switchColorForGroup(@currentGroup, (Colors[aButton.tag - 100])[1])
    end
  end
  
  # Sharing functionality
  def actionSheet(sheet, clickedButtonAtIndex:index)
    if sheet === @shareSheet 
      case index
      when 0
        self.tweetPhoto
      when 1
        self.mailPhoto
      when 2
        return
      end
    elsif sheet === @paintSheet
      case index
      when 0
        @currentGroup = MFGroupWall
      when 1
        @currentGroup = MFGroupOther
      when 2
        return
      end
      
      @currentlyEditing = MFEditingGroup
      self.toggleAnimation
    end
  end
  
  def tweetPhoto
    controller = TWTweetComposeViewController.new
    controller.setInitialText(TwitterText)
    controller.addImage(@stackImageView.getImage)
    controller.completionHandler = lambda { |result| dismissModalViewControllerAnimated(true) }
    presentModalViewController(controller, animated:true)
  end
  
  def mailPhoto
    mailer = MFMailComposeViewController.alloc.init
    mailer.mailComposeDelegate = self
    mailer.setSubject(MailSubject)
    mailer.addAttachmentData(UIImagePNGRepresentation(@stackImageView.getImage), mimeType:"image/png", fileName:MailFilename)
    mailer.setMessageBody(MailBody, isHTML:false)
    self.presentModalViewController(mailer, animated:true)
  end
  
  def mailComposeController(controller, didFinishWithResult:result, error:error)
    self.dismissModalViewControllerAnimated(true)
  end
end
