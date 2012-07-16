class CalculatorVC < UITableViewController
  Description = "Bereken hier de hoeveelheid verf die u nodig heeft."
  Information = "Moose F: Muren (geschaafd en al geverfd hout)\nMoose RDM: Kozijnen, deuren, windveren\nMoose S: alleen voor ruw onbewerkt hout"
  
  Types = [
    ["Moose F", 5],
    ["Moose S", 4],
    ["Moose RDM", 10],
  ]
  
  PerLiter = [5, 4, 10, 5]
  
  attr_accessor :delegate
    
  def viewDidLoad
    @amounts ||= Array.new(4, 0)
    @calc_amounts ||= Array.new(4, 0)
    @tf ||= Array.new(4)
    
    # Make a header view
    headerView = UIView.alloc.initWithFrame([[0, 0], [0, 130]])
    
    descView = UITextView.alloc.initWithFrame([[10, 0], [300, 60]])
    descView.editable = false
    descView.backgroundColor = nil
    descView.font = UIFont.boldSystemFontOfSize(16.0)
    descView.textColor = UIColor.colorWithRed(0.22, green:0.33, blue:0.5, alpha:1.0)
    descView.text = Description
    headerView.addSubview(descView)
    
    infoView = UITextView.alloc.initWithFrame([[10, 60], [300, 80]])
    infoView.editable = false
    infoView.backgroundColor = nil
    infoView.font = UIFont.systemFontOfSize(12.0)
    infoView.textColor = UIColor.colorWithRed(0.22, green:0.33, blue:0.5, alpha:1.0)
    infoView.text = Information
    headerView.addSubview(infoView)
        
    ## FOOTER   
    footerView = UIView.alloc.initWithFrame([[0, 0], [0, 120]])
          
    orderButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    orderButton.frame = [[10, 10], [300, 45]]
    orderButton.setTitle("Bestel", forState:UIControlStateNormal)
    orderButton.addTarget(self, action:'orderTapped', forControlEvents:UIControlEventTouchUpInside)
    footerView.addSubview(orderButton)
    
    hideButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    hideButton.frame = [[10, 60], [300, 45]]
    hideButton.setTitle("Verberg", forState:UIControlStateNormal)
    hideButton.addTarget(self, action:'actionTapped', forControlEvents:UIControlEventTouchUpInside)
    footerView.addSubview(hideButton)
    
    tableView.tableHeaderView = headerView
    tableView.tableFooterView = footerView
  end
    
  # Data-source
  def numberOfSectionsInTableView(tableView)
    4
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    2
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    case indexPath.section
    when 0 then 
      if indexPath.row === 0 
        cellWithTitle("Moose F", editable:true, tag:0)
      else
        cellWithTitle("Moose S", editable:true, tag:1)
      end
    when 1 then 
      if indexPath.row === 0 
        cellWithTitle("Moose RDM", editable:true, tag:2)
      else
        cellWithTitle("Moose F", editable:true, tag:3)
      end
    when 2 then 
      if indexPath.row === 0 
        cellWithTitle("Moose F", editable:false, tag:4)
      else
        cellWithTitle("Moose S", editable:false, tag:5)
      end
    when 3 then
      if indexPath.row === 0 
        cellWithTitle("Moose RDM", editable:false, tag:6)
      else
        cellWithTitle("Moose F", editable:false, tag:7)
      end
    end
  end
  
  def cellWithTitle(title, editable:editable, tag:tag)
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:nil)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  	cell.textLabel.text = title;
  
	  
    meterFrame = [[190, 12], [0, 0]]
		meterLabel = UILabel.alloc.initWithFrame(meterFrame)
		meterLabel.font = UIFont.boldSystemFontOfSize(16.0)
    meterLabel.textColor = UIColor.colorWithRed(0.22, green:0.33, blue:0.5, alpha:1.0)
    meterLabel.sizeToFit
    meterLabel.backgroundColor = UIColor.colorWithRed(0.0, green:0.0, blue:0.0, alpha:0.0)
		
  	if editable then
  	  tf = UITextField.alloc.init
      tf.frame = [[160, 12], [30, 30]]
    	tf.tag = 100 + tag
      tf.textColor = UIColor.colorWithRed(0.22, green:0.33, blue:0.5, alpha:1.0)
      tf.text = @amounts[tag].to_s
  	  tf.placeholder = "0"
  	  tf.keyboardType = UIKeyboardTypeNumbersAndPunctuation
  	  tf.addTarget(self, action:"textFieldStarted:", forControlEvents:UIControlEventEditingDidBegin)
  	  tf.addTarget(self, action:"textFieldFinished:", forControlEvents:UIControlEventEditingDidEnd)
  		tf.addTarget(self, action:"textFieldFinished:", forControlEvents:UIControlEventEditingDidEndOnExit)
    	tf.delegate = self
      tf.adjustsFontSizeToFitWidth = true
      meterLabel.text = "m2"
      cell.addSubview(tf)
  	else
  	  @tf[tag - 4] = UILabel.alloc.init
      @tf[tag - 4].frame = [[160, 6], [30, 30]]
      @tf[tag - 4].backgroundColor = UIColor.colorWithRed(0.0, green:0.0, blue:0.0, alpha:0.0)
    	@tf[tag - 4].tag = 100 + tag
      @tf[tag - 4].textColor = UIColor.colorWithRed(0.0, green:0.0, blue:0.0, alpha:1.0)
	    @tf[tag - 4].text = @calc_amounts[tag - 4].to_s
	    meterLabel.text = "Emmers / 4L"
	    cell.addSubview(@tf[tag - 4])
    end
    meterLabel.sizeToFit
		  
    cell.addSubview(meterLabel)
		
  	cell
  end
  
  def tableView(tableView, titleForHeaderInSection:section)
    result = case section
      when 0 then "Muur"
      when 1 then "Overig"
      when 2 then "Emmers voor muur"
      when 3 then "Emmers voor overig"
    end
  end
  
  def updateAmount
    for i in 0..3 
      @calc_amounts[i] = (@amounts[i] / PerLiter[i].to_f).ceil.to_s
    end
    tableView.reloadData
  end
  
  # textfield delegate
 #def textFieldDidEndEditing(textField)
  #  self.textFieldFinished(textField)
 # end
  def textFieldStarted(tf)
    tf.text = ""
  end
  
  def textFieldFinished(tf)
    id = tf.tag - 100
    m2 = tf.text.to_i
    @amounts[id] = m2
    updateAmount
  end
  
  def actionTapped
    delegate.dismissViewControllerAnimated(true, completion:lambda {})
  end
  
  def orderTapped
    url = NSURL.URLWithString("http://www.moosefarg.com/Zweedse-houtverf-verf-kopen-bestellen.htm");
    UIApplication.sharedApplication.openURL(url)
  end  
end