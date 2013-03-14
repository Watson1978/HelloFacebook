class AppDelegate
  attr_accessor :window
  attr_accessor :viewController
  attr_accessor :session

  def application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    # attempt to extract a token from the url
    self.session.handleOpenURL(url)
  end

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.viewController = SLViewController.alloc.initWithNibName(nil, bundle: nil)
    self.window.rootViewController = self.viewController
    self.window.makeKeyAndVisible
    true
  end

  def applicationDidBecomeActive(application)
    FBSession.activeSession.handleDidBecomeActive
  end
end
