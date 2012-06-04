class CalculatorVC < UITableViewController
  Description = "Bereken hier de hoeveelheid verf die u nodig heeft."
  
  Types = [
    ["Moose F", 3..7],
    ["Moose S", 3..5],
    ["Moose RDM", 10],
  ]
  
  attr_accessor :delegate
    
  def viewDidLoad
    # Make a header view
    headerView = UIView.alloc.initWithFrame([[0, 0], [0, 60]])
    
    descView = UITextView.alloc.initWithFrame([[10, 0], [300, 60]])
    descView.editable = false
    descView.backgroundColor = nil
    descView.font = UIFont.boldSystemFontOfSize(16.0)
    descView.textColor = UIColor.colorWithRed(0.22, green:0.33, blue:0.5, alpha:1.0)
    descView.text = Description
    headerView.addSubview(descView)
        
    footerView = UIView.alloc.initWithFrame([[0, 0], [0, 90]])
    
    orderButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    orderButton.frame = [[30, 10], [120, 45]]
    orderButton.setTitle("Bestel", forState:UIControlStateNormal)
    # orderButton.addTarget(self, action:'', forControlEvents:UIControlEventTouchUpInside)
    footerView.addSubview(orderButton)
    
    hideButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    hideButton.frame = [[170, 10], [120, 45]]
    hideButton.setTitle("Verberg", forState:UIControlStateNormal)
    hideButton.addTarget(self, action:'actionTapped', forControlEvents:UIControlEventTouchUpInside)
    footerView.addSubview(hideButton)
    
    tableView.tableHeaderView = headerView
    tableView.tableFooterView = footerView
  end
    
  # Data-source
  def numberOfSectionsInTableView(tableView)
    1
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    Types.count
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    type = Types[indexPath.row]
    
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:nil)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  	cell.textLabel.text = type[0];
  	
    tf = UITextField.alloc.init
    tf.placeholder = "0"
    tf.textColor = UIColor.colorWithRed(0.22, green:0.33, blue:0.5, alpha:1.0)
		tf.addTarget(self, action:"textFieldFinished:", forControlEvents:UIControlEventEditingDidEndOnExit)
  	tf.delegate = self
  	tf.frame = [[160, 12], [30, 30]]
    tf.adjustsFontSizeToFitWidth = true
    tf.tag = 100 + indexPath.row
  	cell.addSubview(tf)
		
		meterFrame = [[190, 12], [0, 0]]
		meterLabel = UILabel.alloc.initWithFrame(meterFrame)
		meterLabel.text = "m2"
		meterLabel.font = UIFont.boldSystemFontOfSize(16.0)
    meterLabel.textColor = UIColor.colorWithRed(0.22, green:0.33, blue:0.5, alpha:1.0)
    meterLabel.sizeToFit
    meterLabel.backgroundColor = UIColor.colorWithRed(0.0, green:0.0, blue:0.0, alpha:0.0)
		cell.addSubview(meterLabel)
		
  	cell
  end
  
  # textfield delegate
  
  def textFieldDidEndEditing(textField)
    self.textFieldFinished(textField)
  end
  
  def textFieldFinished(tf)
    id = tf.tag - 100
    m2 = tf.text.to_i
    puts id
  end
  
  def actionTapped
    delegate.dismissViewControllerAnimated(true, completion:lambda {})
  end  
end