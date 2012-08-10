class NSString
  def local
    NSBundle.mainBundle.localizedStringForKey(self, value:nil, table:nil)
  end
end

module Kernel
  def t(str) 
    NSBundle.mainBundle.localizedStringForKey(str, value:nil, table:nil)
  end
end