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
		  	
  	cell
  end
  
  def actionTapped
    delegate.dismissViewControllerAnimated(true, completion:lambda {})
  end  
end