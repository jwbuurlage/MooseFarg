class RegistrationVC < UITableViewController
  POSTMARK_API_KEY = "7d4a30d7-4ed1-4130-9b2b-8caa14831987"
  Description = "Hier kunt u zich aanmelden voor de nieuwsbrief."
  
  Fields = [
    ["Name", "Jan Jansen", :name],
    ["Plaats", "Hoofddorp", :location],
    ["Postcode", "1234 AB", :zipcode],
    ["E-mail", "jan@jansen.nl", :email]
    # ["Adres", "Dorpsstraat 123", :address],
    # ["Tel.", "1234-123456", :telephone],
    # ["Ken van", "Google", :how], 
  ]

  attr_accessor :delegate
  
  # Initialization
  def viewDidLoad
    @values ||= Array.new(Fields.length, "")
    
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
    
    registerButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    registerButton.frame = [[30, 10], [120, 45]]
    registerButton.setTitle("Registreer", forState:UIControlStateNormal)
    registerButton.addTarget(self, action:'send_postmark', forControlEvents:UIControlEventTouchUpInside)
    footerView.addSubview(registerButton)
    
    closeButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    closeButton.frame = [[160, 10], [120, 45]]
    closeButton.setTitle("Verberg", forState:UIControlStateNormal)
    closeButton.addTarget(self, action:'close', forControlEvents:UIControlEventTouchUpInside)
    footerView.addSubview(closeButton)
    
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
    self.textFieldFinished(textField)
  end
  
  def textFieldFinished(textField)
    # select by placeholder
    field = Fields.find_index { |(title, placeholder, symbol)| placeholder === textField.placeholder }
    @values[field] = textField.text
  end
  
  def form_body
    form_body = "De volgende persoon heeft zich zojuist aangemeld voor de nieuwsbrief (via iOS) <br /> <br />"
    Fields.each_with_index do |(titel, placeholder, symbol), i|
      form_body += "<b>#{titel}</b>: #{@values[i]} <br />"
    end
    form_body += "<br /> Groet, <br /><br /> De Moose Farg iPhone app"
    form_body
  end
  
  def send_postmark
    apiURL = NSURL.URLWithString "http://api.postmarkapp.com/email"
    
    body = '{
      "From" : "jwbuurlage@me.com",
      "To" : "jan@moosefarg.com",
      "Subject" : "Nieuwe Registratie Moose Farg Nieuwsbrief // iPhone",
      "Tag" : "Registratie, iPhone",
      "HtmlBody" : "' + form_body + '",
      "TextBody" : "' + form_body + '",
      "ReplyTo" : "jwbuurlage@me.com"
    }'
    
    data = body.dataUsingEncoding NSUTF8StringEncoding
    
    length = data.length.to_s
    
    request = NSMutableURLRequest.alloc.initWithURL apiURL
    request.HTTPMethod = "POST"
    request.HTTPBody = data
    
    request.setValue(length, forHTTPHeaderField:"Content-Length")
    request.setValue("application/json" , forHTTPHeaderField:"Content-Type")
    request.setValue("application/json" , forHTTPHeaderField:"Accept")
    request.setValue(POSTMARK_API_KEY, forHTTPHeaderField:"X-Postmark-Server-Token")
    
    completionLambda = lambda do |response, responseData, error|
      response = NSString.alloc.initWithData(responseData, encoding: NSUTF8StringEncoding)
      puts response
    end
    
    NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue, completionHandler: completionLambda)
    
    close
  end
  
  def close 
    delegate.dismissViewControllerAnimated(true, completion:lambda {})
  end
end