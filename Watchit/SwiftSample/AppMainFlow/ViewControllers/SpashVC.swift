
import Foundation
import UIKit

class SplashVC: BaseViewController{
    
 
    
    @IBOutlet var splashView: SplashView!
    var isFirstTimeLaunch : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
      //  callCheckVersion()
    }
    
    
    class func initWithStory() -> SplashVC {
        let splash : SplashVC = UIStoryboard.AppMainFlow.instantiateViewController()
       // splash.accViewModel = AccountViewModel()
        return splash
    }
    
    func callCheckVersion(){
        
       // SceneDelegate.shared.setTabbarForSwithUsers()
        LocalStorage.shared.setSting(.accessToken, text: "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZDk1MDFiNzg2NjlmYjJkN2U2NWQ0MmQ3NzkyNDk4MCIsInN1YiI6IjY1MmZiMDViY2FlZjJkMDBjNTI3ZTBkYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7UPhFQQpg3o_EKEHE_49HcuIgHqA5yvT-CAp-H6DMj4")
        if let sceneDelegate = self.view?.window?.windowScene?.delegate as? SceneDelegate {
          
            sceneDelegate.setLoginPage()
          //  sceneDelegate.setTabbarForSwithUsers()
        }
        

    }
}
