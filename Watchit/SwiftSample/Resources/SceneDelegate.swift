

import UIKit



class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var watchitTabBarCtrler : WatchitTabBar?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        if let windowScene = scene as? UIWindowScene {
             let window = UIWindow(windowScene: windowScene)
            let splashView = SplashVC.initWithStory()
            window.rootViewController = splashView
             self.window = window
             window.makeKeyAndVisible()
         }
        
    }
    
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func generateWatchitLoginFlowChange(tabIcon: Int) -> UITabBarController
    {
        watchitTabBarCtrler?.guestTabBarSetup(tabIcon)
        return watchitTabBarCtrler ?? WatchitTabBar()
    }
    
    
    func setTabbarForSwithUsers()
    {
        let splashVc = self.generateWatchitLoginFlowChange(tabIcon: 0)
         self.window?.rootViewController = splashVc
    }
    
    func setLoginPage()
    {
        var firstVC = UIViewController()
        let state =  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserLoggedin)
        if !state {
            firstVC = LoginVC.initWithStory()
            let rootController = UINavigationController(rootViewController: firstVC)
            self.window?.rootViewController = rootController
        }else {
            setTabbarForSwithUsers()

        }
      
    }
    
    func generateTabbarController() -> UITabBarController
    {
        
        self.watchitTabBarCtrler = WatchitTabBar()
        self.watchitTabBarCtrler?.guestTabBarSetup()
        window?.rootViewController = watchitTabBarCtrler
        return watchitTabBarCtrler ?? WatchitTabBar()
    }


}



//MARK: - Toast Creation
extension SceneDelegate {
    /// Display Toast Message

    func createToastMessage(_ strMessage:String,
                            bgColor: UIColor = .white,
                            textColor: UIColor = .white, isFromSearch: Bool? = false, isFromWishList: Bool? = false)
    {
        guard let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive || $0.activationState == .background || $0.activationState == .foregroundInactive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first else { return }
        var lblMessage = UILabel()
        var backgroundHolderView=UIView()
        backgroundHolderView.isUserInteractionEnabled = false
        if !isFromSearch! && !isFromWishList! {
            lblMessage=UILabel(frame: CGRect(x: 0,
                                                y: keyWindow.frame.height + 70,
                                                width: keyWindow.frame.size.width,
                                                height: 70))
        } else if isFromSearch!{
            
            
            
            lblMessage=UILabel(frame: CGRect(x: 0,
                                                y: keyWindow.frame.size.height -  keyWindow.frame.size.height / 20,
                                                width: keyWindow.frame.size.width,
                                             height: keyWindow.frame.size.height / 20))
        } else if isFromWishList! {
            backgroundHolderView=UIView(frame: CGRect(x: keyWindow.width / 1.2 -  keyWindow.width / 1.2 / 1.1, y: keyWindow.bottom - keyWindow.height / 15 , width: keyWindow.width / 1.2, height: keyWindow.height / 20))
//            UIView(frame: CGRect(x: (keyWindow.width / 1.2) / 2 - (keyWindow.width / 1.2) / 2.5,
//                                                      y: keyWindow.frame.size.height -  keyWindow.frame.size.height / 15 - (keyWindow.frame.size.height/20),
//                                                      width: keyWindow.frame.size.width/1.2,
//                                                   height: keyWindow.frame.size.height / 15))
            lblMessage.clipsToBounds = true
            lblMessage.frame=backgroundHolderView.bounds
//                UILabel(frame: CGRect(x: backgroundHolderView.left + 5,
//                                                 y: backgroundHolderView.top + 5,
//                                                 width: backgroundHolderView.width - 10,
//                                                 height: backgroundHolderView.height - 10))
        }
        lblMessage.tag = 500
        lblMessage.text = strMessage
        lblMessage.textAlignment = NSTextAlignment.center
        lblMessage.numberOfLines = 0
      //  moveLabelToYposition(lblMessage)
        if !isFromSearch! && !isFromWishList! {
            lblMessage.textColor = .white
            lblMessage.backgroundColor = .cyan
            lblMessage.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            lblMessage.layer.shadowColor = UIColor.darkGray.cgColor
            moveLabelToYposition(lblMessage,
                                 win: keyWindow)
            keyWindow.addSubview(lblMessage)
           
        } else if isFromSearch!{
            lblMessage.textColor = .label
            lblMessage.backgroundColor = .systemBackground
            lblMessage.font = UIFont.systemFont(ofSize: 14, weight: .light)
            lblMessage.layer.shadowColor = UIColor.darkGray.cgColor
            moveSearchLabelToYposition(lblMessage,
                                       win: keyWindow)
            keyWindow.addSubview(lblMessage)
        } else if isFromWishList! {
            lblMessage.textColor = .black
           // lblMessage.backgroundColor = .systemBackground
            lblMessage.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            backgroundHolderView.cornerRadius = backgroundHolderView.height / 2
            backgroundHolderView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            backgroundHolderView.layer.borderWidth = 0.5
            backgroundHolderView.layer.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8).cgColor
           // backgroundHolderView.layer.cornerRadius =  backgroundHolderView.height / 6
           // backgroundHolderView.elevate(2, radius:  backgroundHolderView.height / 4)
            keyWindow.addSubview(backgroundHolderView)
            backgroundHolderView.addSubview(lblMessage)
            moveWishlistToastToYposition(backgroundHolderView,
                                       win: keyWindow)
            
        }
    }
    
    func onWishListCloseAnimation(_ holderView:UIView,
                          win: UIWindow) {
        UIView.animate(withDuration: 2,
                       delay: 3.5,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            holderView.frame = CGRect(x: win.width / 1.2  - win.width / 1.2 / 1.1,
                                            y: win.bottom + win.height / 15,
                                            width: win.width / 1.2,
                                         height: win.height / 15)
        }, completion: { (finished: Bool) -> Void in
            holderView.removeFromSuperview()
        })
    }
    
    
    func moveWishlistToastToYposition(_ holderView:UIView,
                              win: UIWindow) {
        UIView.animate(withDuration: 2,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            holderView.frame = CGRect(x: win.width / 1.2 - win.width / 1.2 / 1.1,
                                      y: win.bottom + win.height / 15,
                                      width: win.width / 1.2,
                                   height: win.height / 15)
            
            
        }, completion: { (finished: Bool) -> Void in
            self.onWishListCloseAnimation(holderView,
                                   win: win)
        })
    }

    
    func moveSearchLabelToYposition(_ lblView:UILabel,
                              win: UIWindow) {
        UIView.animate(withDuration: 0.9,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            lblView.frame = CGRect(x: 0,
                                   y: (win.frame.size.height) - win.frame.size.height / 20 ,
                                   width: win.frame.size.width,
                                   height: win.frame.size.height / 20)
        }, completion: { (finished: Bool) -> Void in
            self.onSearchCloseAnimation(lblView,
                                   win: win)
        })
    }
    func onSearchCloseAnimation(_ lblView:UILabel,
                          win: UIWindow) {
        UIView.animate(withDuration: 0.3,
                       delay: 3.5,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            lblView.frame = CGRect(x: 0,
                                   y:  (win.frame.size.height) + win.frame.size.height / 20,
                                   width: (win.frame.size.width),
                                   height: win.frame.size.height / 20)
        }, completion: { (finished: Bool) -> Void in
            lblView.removeFromSuperview()
        })
    }


    
    func moveLabelToYposition(_ lblView:UILabel)
    {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            lblView.frame = CGRect(x: 0, y: (self.window?.frame.size.height)!-70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 70)
            }, completion: { (finished: Bool) -> Void in
                self.onCloseAnimation(lblView)
        })
    }
    
    func onCloseAnimation(_ lblView:UILabel)
    {
        UIView.animate(withDuration: 0.3, delay: 3.5, options: UIView.AnimationOptions(), animations: { () -> Void in
            lblView.frame = CGRect(x: 0, y: (self.window?.frame.size.height)!+70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 70)
            }, completion: { (finished: Bool) -> Void in
                lblView.removeFromSuperview()
        })
    }
    
    func createToastMessage(_ strMessage:String,
                            bgColor: UIColor = .GuestThemeColor,
                            textColor: UIColor = .GuestThemeColor) {
        if #available(iOS 13.0, *) {
            guard let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive || $0.activationState == .background || $0.activationState == .foregroundInactive})
                    .compactMap({$0 as? UIWindowScene})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first else { return }
            let lblMessage=UILabel(frame: CGRect(x: 0,
                                                 y: keyWindow.frame.height + 70,
                                                 width: keyWindow.frame.size.width,
                                                 height: 70))
            lblMessage.tag = 500
//            lblMessage.text = NetworkManager.instance.isNetworkReachable ? strMessage : "N0 internet connection" //CommonError.connection.localizedDescription
            lblMessage.text = strMessage
            lblMessage.textColor = .white
            lblMessage.backgroundColor = .GuestThemeColor
            //lblMessage.font = ToastTheme.MessageText.font
            lblMessage.textAlignment = NSTextAlignment.center
            lblMessage.numberOfLines = 0
            //lblMessage.layer.shadowColor = .GuestThemeColor.cgColor;
            lblMessage.layer.shadowOffset = CGSize(width:0, height:1.0);
            lblMessage.layer.shadowOpacity = 0.5;
            lblMessage.layer.shadowRadius = 1.0;
            moveLabelToYposition(lblMessage,
                                 win: keyWindow)
            keyWindow.addSubview(lblMessage)
        } else {
            guard let window = UIApplication.shared.keyWindow else{return}
            let lblMessage=UILabel(frame: CGRect(x: 0,
                                                 y: window.frame.size.height + 70,
                                                 width: window.frame.size.width,
                                                 height: 70))
            lblMessage.tag = 500
//            lblMessage.text = NetworkManager.instance.isNetworkReachable ? strMessage : "N0 internet connection" //CommonError.connection.localizedDescription
            lblMessage.text = strMessage
            lblMessage.textColor = .white
            lblMessage.backgroundColor = .GuestThemeColor
            //lblMessage.font = ToastTheme.MessageText.font
            lblMessage.textAlignment = NSTextAlignment.center
            lblMessage.numberOfLines = 0
            //lblMessage.layer.shadowColor = .GuestThemeColor.color.cgColor;
            lblMessage.layer.shadowOffset = CGSize(width:0, height:1.0);
            lblMessage.layer.shadowOpacity = 0.5;
            lblMessage.layer.shadowRadius = 1.0;
            moveLabelToYposition(lblMessage,
                                 win: window)
            window.addSubview(lblMessage)
        }
    }
    
    func createToastMessageForAlamofire(_ strMessage : String,
                                        bgColor: UIColor = .GuestThemeColor,
                                        textColor: UIColor = .GuestThemeColor,
                                        forView:UIView) {
        let lblMessage=UILabel(frame: CGRect(x: 0,
                                             y: (forView.frame.size.height)+70,
                                             width: (forView.frame.size.width),
                                             height: 70))
        lblMessage.tag = 500
    //    lblMessage.text = NetworkManager.instance.isNetworkReachable ? strMessage : "N0 internet connection"//CommonError.connection.localizedDescription
        lblMessage.textColor = .white
        lblMessage.backgroundColor = .GuestThemeColor
        //lblMessage.font = ToastTheme.MessageText.font
        lblMessage.textAlignment = NSTextAlignment.center
        lblMessage.numberOfLines = 0
        //lblMessage.layer.shadowColor = .GuestThemeColor.color.cgColor;
        lblMessage.layer.shadowOffset = CGSize(width:0, height:1.0);
        lblMessage.layer.shadowOpacity = 0.5;
        lblMessage.layer.shadowRadius = 1.0;
        downTheToast(lblView: lblMessage,
                     forView: forView)
        UIApplication.shared.keyWindow?.addSubview(lblMessage)
    }
    
    func downTheToast(lblView:UILabel,
                      forView:UIView) {
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .curveEaseInOut ,
                       animations: { () -> Void in
            lblView.frame = CGRect(x: 0,
                                   y: (forView.frame.size.height)-70,
                                   width: (forView.frame.size.width),
                                   height: 70)
        }, completion: { (finished: Bool) -> Void in
            self.closeTheToast(lblView,
                               forView: forView)
        })
    }
    
    func closeTheToast(_ lblView:UILabel,
                       forView:UIView) {
        UIView.animate(withDuration: 0.3,
                       delay: 3.5,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            lblView.frame = CGRect(x: 0,
                                   y: (forView.frame.size.height)+70,
                                   width: (forView.frame.size.width),
                                   height: 70)
        }, completion: { (finished: Bool) -> Void in
            lblView.removeFromSuperview()
        })
    }
    /// Show the Animation
    func moveLabelToYposition(_ lblView:UILabel,
                              win: UIWindow) {
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            lblView.frame = CGRect(x: 0,
                                   y: (win.frame.size.height)-70,
                                   width: win.frame.size.width,
                                   height: 70)
        }, completion: { (finished: Bool) -> Void in
            self.onCloseAnimation(lblView,
                                  win: win)
        })
    }
    // MARK: - close the Animation
    func onCloseAnimation(_ lblView:UILabel,
                          win: UIWindow) {
        UIView.animate(withDuration: 0.3,
                       delay: 3.5,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            lblView.frame = CGRect(x: 0,
                                   y: (win.frame.size.height)+70,
                                   width: (win.frame.size.width),
                                   height: 70)
        }, completion: { (finished: Bool) -> Void in
            lblView.removeFromSuperview()
        })
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     //   self.pushNotificationHanlder?.regiserForRemoteNotification()
    }
    
}

    
    

