class RegistrationVC < UITableViewController    
  POSTMARK_API_KEY = "7d4a30d7-4ed1-4130-9b2b-8caa14831987"
  
  Fields = [
    [t("name_field"), t("name_placeholder"), :name],
    [t("city_field"), t("city_placeholder"), :location],
    [t("zip_field"), t("zip_placeholder"), :zipcode],
    [t("email_field"), t("email_placeholder"), :email]
  ]

  attr_accessor :delegate
  
  ERROR_EMPTY_FIELD = 0
  ERROR_INVALID_EMAIL = 1
  
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
    descView.text = t("registration_description")
    headerView.addSubview(descView)
        
    footerView = UIView.alloc.initWithFrame([[0, 0], [0, 160]])
    
    registerButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    registerButton.frame = [[10, 10], [300, 45]]
    registerButton.setTitle(t("register_title"), forState:UIControlStateNormal)
    registerButton.addTarget(self, action:'register', forControlEvents:UIControlEventTouchUpInside)
    footerView.addSubview(registerButton)
    
    closeButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    closeButton.frame = [[10, 60], [300, 45]]
    closeButton.setTitle(t("hide_title"), forState:UIControlStateNormal)
    closeButton.addTarget(self, action:'close', forControlEvents:UIControlEventTouchUpInside)
    footerView.addSubview(closeButton)
    
    vCardButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    vCardButton.frame = [[10, 110], [300, 45]]
    vCardButton.setTitle("Jan Smit (Moose F\u00E4rg)", forState:UIControlStateNormal)
    vCardButton.setTitleColor(UIColor.grayColor, forState:UIControlStateDisabled)    
    vCardButton.addTarget(self, action:'addVCard:', forControlEvents:UIControlEventTouchUpInside)
    footerView.addSubview(vCardButton)
    
    @iconButton = UIButton.buttonWithType(UIButtonTypeContactAdd)
    @iconButton.frame = [[20, 110], [45, 45]]
    @iconButton.setUserInteractionEnabled false
    footerView.addSubview(@iconButton)
    
    tableView.tableHeaderView = headerView
    tableView.tableFooterView = footerView
  end
  
  def addVCard(sender)     
    addressBook = ABAddressBookCreate()
    person = ABPersonCreate()
    ABRecordSetValue(person, KABPersonFirstNameProperty, "Jan", nil)
    ABRecordSetValue(person, KABPersonLastNameProperty, "Smit", nil)
    ABRecordSetValue(person, KABPersonOrganizationProperty, "Moose F\u00E4rg", nil)
    
    phoneNumberMultiValue = ABMultiValueCreateMutable(KABPersonPhoneProperty); 
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue, "(+31) 06 55333165", KABPersonPhoneMobileLabel, nil);
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue, "(+31) 0224 217071", KABPersonPhoneMainLabel, nil);
    ABRecordSetValue(person, KABPersonPhoneProperty, phoneNumberMultiValue, nil); 
        
    emailMultiValue = ABMultiValueCreateMutable(KABPersonEmailProperty);
    ABMultiValueAddValueAndLabel(emailMultiValue, "jan@moosefarg.com", KABWorkLabel, nil);
    ABRecordSetValue(person, KABPersonEmailProperty, emailMultiValue, nil);

    addressMultiValue = ABMultiValueCreateMutable(KABMultiDictionaryPropertyType);
    dict = {
      KABPersonAddressStreetKey => "De Dreef 32",
      KABPersonAddressZIPKey => "1741 MH", 
      KABPersonAddressCityKey => "Schagen",
      KABPersonAddressStateKey => "Noord-Holland", 
      KABPersonAddressCountryKey =>"The Netherlands", 
      KABPersonAddressCountryCodeKey => "nl"
    }
    ABMultiValueAddValueAndLabel(addressMultiValue, dict, KABWorkLabel, nil);
    ABRecordSetValue(person, KABPersonAddressProperty, addressMultiValue, nil);

    ABAddressBookAddRecord(addressBook, person, nil)
    ABAddressBookSave(addressBook, nil)
    
    sender.enabled = false
    @iconButton.enabled = false
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
  
  def error(type)
    text = ""
        
    case type
    when ERROR_EMPTY_FIELD
      text = t("error_empty_field")
    when ERROR_INVALID_EMAIL
      text = t("error_invalid_email")
    end
    
    alert = UIAlertView.alloc.init
    alert.title = "Error"
    alert.message = text
    alert.addButtonWithTitle(t("cancel_title"))
    alert.setCancelButtonIndex(0)
    alert.show
  end
  
  def register
    @values.each do |value|
      if value === "" 
        self.error ERROR_EMPTY_FIELD
        return
      end
    end
    
    if not (@values[3] =~ /@/)
      self.error ERROR_INVALID_EMAIL
      return
    end
      
    self.send_postmark
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