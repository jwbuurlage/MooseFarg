class RegistrationVC < UITableViewController
  Description = "Om deze app te gebruiken dient u zich eenmalig te registreren."
  
  Fields = [
    ["Name", "Jan Jansen", :name],
    ["Adres", "Dorpsstraat 123", :address],
    ["Postcode", "1234 AB", :zipcode],
    ["Plaats", "Hoofddorp", :location],
    ["E-mail", "jan@jansen.nl", :email],
    ["Tel.", "1234-123456", :telephone],
    ["Ken van", "Google", :how], 
  ]
  
  attr_accessor :delegate
  
  # Initialization
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
    
    testButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    testButton.frame = [[85, 10], [150, 60]]
    testButton.setTitle("Registreer", forState:UIControlStateNormal)
    testButton.addTarget(self, action:'actionTapped', forControlEvents:UIControlEventTouchUpInside)
    footerView.addSubview(testButton)
    
    tableView.tableHeaderView = headerView
    tableView.tableFooterView = footerView
    
  end
  
  # Data-source
  def numberOfSectionsInTableView(tableView)
    1
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    Fields.count
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    field = Fields[indexPath.row]
    
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:nil)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  	cell.textLabel.text = field[0];
		
  	tf = self.textFieldWithPlaceholder(field[1])
  	tf.frame = [[120, 12], [170, 30]]
  	tf.addTarget(self, action:"textFieldFinished:", forControlEvents:UIControlEventEditingDidEndOnExit)
  	tf.delegate = self
  	cell.addSubview(tf)
  	
  	cell
  end
  
  # Custom Textfields
  def textFieldWithPlaceholder(placeholder)
    tf = UITextField.alloc.init
    tf.placeholder = placeholder
    tf.adjustsFontSizeToFitWidth = true
    tf.textColor = UIColor.colorWithRed(0.22, green:0.33, blue:0.5, alpha:1.0)
    tf
  end
  
  # UITextField delegate
  def textFieldDidEndEditing(textField)
    # select by placeholder
  end
  
  def textFieldFinished(textField)
    # select by placeholder
    field = Fields.find { |(title, placeholder, symbol)| placeholder === textField.placeholder }
    p field[2]
  end
  
  def actionTapped
    delegate.dismissViewControllerAnimated(true, completion:lambda {})
  end
  
  
end