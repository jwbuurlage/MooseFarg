class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)   
    application.statusBarStyle = UIStatusBarStyleBlackOpaque
     
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = PaintVC.alloc.init
    @window.makeKeyAndVisible
    true
  end
end