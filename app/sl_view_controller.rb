class SLViewController < UIViewController
  attr_accessor :textNoteOrLink
  attr_accessor :buttonLoginLogout

  def viewDidLoad
    super

    @textNoteOrLink = UILabel.alloc.initWithFrame([[0, 50], [view.frame.size.width, 150]])
    view.addSubview(@textNoteOrLink)

    @buttonLoginLogout = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @buttonLoginLogout.setTitle('Log in', forState:UIControlStateNormal)
    @buttonLoginLogout.addTarget(self, action:'buttonClickHandler', forControlEvents:UIControlEventTouchUpInside)
    @buttonLoginLogout.frame = [[view.frame.size.width / 2 - 40, 220], [80, 40]]
    view.addSubview(@buttonLoginLogout)

    appDelegate = UIApplication.sharedApplication.delegate
    if appDelegate.session.nil?
      # create a fresh session object
      appDelegate.session = FBSession.alloc.init
    end

    self.updateView

    if !appDelegate.session.isOpen
      # if we don't have a cached token, a call to open here would cause UX for login to
      # occur; we don't want that to happen unless the user clicks the login button, and so
      # we check here to make sure we have a token before calling open
      if appDelegate.session.state == FBSessionStateCreatedTokenLoaded
        # even though we had a cached token, we need to login to make the session usable
        appDelegate.session.openWithCompletionHandler(lambda { |session, status, error|
          # we recurse here, in order to update buttons and labels
          self.updateView
        })
      end
    end

    self
  end

  def updateView
    # get the app delegate, so that we can reference the session property
    appDelegate = UIApplication.sharedApplication.delegate
    if appDelegate.session.isOpen
      # valid account UI is shown whenever the session is open
      self.buttonLoginLogout.setTitle("Log out", forState:UIControlStateNormal)
      self.textNoteOrLink.setText("https://graph.facebook.com/me/friends?access_token=#{appDelegate.session.accessTokenData.accessToken}")
    else
      # login-needed account UI is shown whenever the session is closed
      self.buttonLoginLogout.setTitle("Log in", forState:UIControlStateNormal)
      self.textNoteOrLink.setText("Login to create a link to fetch account data")
    end
  end


  def buttonClickHandler
    # get the app delegate so that we can access the session property
    appDelegate = UIApplication.sharedApplication.delegate

    # this button's job is to flip-flop the session from open to closed
    if appDelegate.session.isOpen
      # if a user logs out explicitly, we delete any cached token information, and next
      # time they run the applicaiton they will be presented with log in UX again; most
      # users will simply close the app or switch away, without logging out; this will
      # cause the implicit cached-token login to occur on next launch of the application
      appDelegate.session.closeAndClearTokenInformation
    else
      if appDelegate.session.state != FBSessionStateCreated
        # Create a new, logged out session.
        appDelegate.session = FBSession.alloc.init
      else
        # if the session isn't open, let's open it now and present the login UX to the user
        appDelegate.session.openWithCompletionHandler(lambda { |session, status, error|
          # and here we make sure to update our UX according to the new session state
          self.updateView
        })
      end
    end
  end

end