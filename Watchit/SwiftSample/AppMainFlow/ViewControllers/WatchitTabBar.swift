

import UIKit

class WatchitTabBar: UITabBarController, UITabBarControllerDelegate {
    
     //  let sharedAppDelegate:AppDelegate =  UIApplication.shared.delegate as! AppDelegate
    var homeNavigation : UINavigationController!
    
    private let indicatorView: UIView = {
          let view = UIView()
          view.backgroundColor = .appHostThemeColor
          return view
      }()
    
    private lazy var indicatorWidth: Double = tabBar.bounds.width / CGFloat(tabBar.items?.count ?? 1)
    private var indicatorColor: UIColor = .red
    
    var menuButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.addSubview(indicatorView)
      //  self.menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: tabBar.bounds.height / 1.7, height: tabBar.bounds.height / 1.7))
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: self.tabBar.bounds.minY, width: self.tabBar.bounds.width, height: self.tabBar.bounds.height), cornerRadius: 0).cgPath
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = 25.0
        layer.shadowOpacity = 0.3
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor.white.cgColor
        self.tabBar.layer.insertSublayer(layer, at: 0)
        
        tabBar.barTintColor = UIColor.white
        self.tabBar.backgroundColor = UIColor.clear
       // self.tabBar.itemWidth = (self.view.frame.width / 5) - 40
        self.tabBar.itemPositioning = .fill
        self.delegate = self
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundImage = nil
        self.tabBar.barStyle = UIBarStyle.black
        self.tabBar.backgroundColor = .clear
        guestTabBarSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Position the line indicator at the bottom of the selected tab item
        menuButton.frame = CGRect.init(x: self.tabBar.center.x - (self.tabBar.frame.size.height / 1.2 / 2) , y: (tabBar.bottom - tabBar.height / 0.7), width: self.tabBar.frame.size.height  , height: self.tabBar.frame.size.height)
        //self.view.bounds.height - (view.bottom - view.height / 1.15)
        self.view.bringSubviewToFront(self.menuButton)
      //  moveIndicator()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.menuButton.removeFromSuperview()
    }
    
    

    
    func moveIndicator(at index: Int=0) {
        let itemWidth = (tabBar.bounds.width / CGFloat(tabBar.items?.count ?? 1))
        let xPosition = (CGFloat(index) * itemWidth) + ((itemWidth / 2) - (indicatorWidth / 2))

        UIView.animate(withDuration: 0.3) { [self] in
            self.indicatorView.frame = CGRect(x: xPosition,
                                              y: 1,
                                              width: self.indicatorWidth,
                                              height: 1)
            self.indicatorView.backgroundColor = self.indicatorColor
        }
    }
    
    func guestTabBarSetup(_ index:Int? = 0) {

        UITabBar.appearance().tintColor =  UIColor.appHostThemeColor
        UITabBar.appearance().barTintColor = UIColor.white

        
        //MARK: - HOME
        
        let homeTabVC = HomeVC.initWithStory()
        homeTabVC.view.backgroundColor = .label
        //HomeVc.initWithStory()
        
        homeNavigation = UINavigationController(rootViewController: homeTabVC)
        let controller1 = homeTabVC
        //GetUserInfoVC.initWithStory(.email)
        

        
        controller1.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        let nav1 = UINavigationController(rootViewController: controller1)
        
        let icon1 = UITabBarItem(title: "Discover", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        nav1.tabBarItem = icon1
        
        //MARK: - WishList
        
        let controller2 = UIViewController()
        controller2.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        let wishlistVC = WishListVC.initWithStory()
      
      
        
        let nav2 = UINavigationController(rootViewController: wishlistVC)
        
        let icon2 = UITabBarItem(title: " Watchlist", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        nav2.tabBarItem = icon2
        
      
        
        nav1.isNavigationBarHidden = true
        nav2.isNavigationBarHidden = true

        let controllers = [nav1,nav2]
        self.viewControllers = controllers
        self.selectedIndex = index!
      //  setTitleAdjustment()
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = tabBar.items else { return }
      //  if tabBar.
        if tabBar.selectedItem?.title == "" {
            indicatorView.removeFromSuperview()
            return
        } else {
            tabBar.addSubview(indicatorView)
            moveIndicator(at: items.firstIndex(of: item) ?? 0)
        }
    }
    
    
    
}
