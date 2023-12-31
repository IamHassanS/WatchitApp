import Foundation
import UIKit

typealias GifLoaderValue = (loader:UIView,
                            count : Int)

class Shared {
    private init(){}
    static let instance = Shared()
    fileprivate let preference = UserDefaults.standard
   var user_logged_in = true
    
    fileprivate var gifLoaders : [UIView:GifLoaderValue] = [:]
    var selectedPhoneCode: String = ""
    static let guestThemeColor = UIColor.init(hex: "#00A699")
    static let hostThemeColor = UIColor.init(hex: "#FF5A5F")
    static let darkThemeColor = UIColor.init(hex: "#00464d")
}
//MARK:- UserDefaults property observers


extension Shared{
    func showLoaderInWindow(){
        DispatchQueue.main.async {
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
            else {
              return
            }
           // let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let window = sceneDelegate.window{
                self.showLoader(in: window)
            }
        }
        
    }
    func removeLoaderInWindow(){
        DispatchQueue.main.async {
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
            else {
              return
            }
           // let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let window = sceneDelegate.window{
                self.removeLoader(in: window)
            }
        }
    }
    func showLoader(in view : UIView) {
        guard Shared.instance.gifLoaders[view] == nil else{return}
        DispatchQueue.main.async {
            let gifValue : GifLoaderValue
            if let existingLoader = self.gifLoaders[view]{
                gifValue = (loader: existingLoader.loader,
                            count: existingLoader.count + 1)
            } else {
                let gif = self.getLoaderGif(forFrame: view.bounds)
                view.addSubview(gif)
                gif.frame = view.frame
                gif.center = view.center
                gifValue = (loader: gif,count: 1)
            }
            Shared.instance.gifLoaders[view] = gifValue
        }
    }
    
    func removeLoader(in view : UIView) {
        guard let existingLoader = self.gifLoaders[view] else{
            return
        }
        let newCount = existingLoader.count - 1
        if newCount == 0 {
            Shared.instance.gifLoaders[view]?.loader.removeFromSuperview()
            Shared.instance.gifLoaders.removeValue(forKey: view)
        }else{
            Shared.instance.gifLoaders[view] = (loader: existingLoader.loader,
                                                count: newCount)
        }
    }
    func getLoaderGif(forFrame parentFrame: CGRect) -> UIView {
        let jeremyGif = UIImage.gifImageWithName("loader")
        let view = UIView()
        view.backgroundColor = UIColor.appHostThemeColor.withAlphaComponent(0.05)
        view.frame = parentFrame
        let imageView = UIImageView(image: jeremyGif)
        imageView.tintColor = .appGuestThemeColor
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.center = view.center
        view.addSubview(imageView)
        view.tag = 2596
        return view
    }
    func isLoading(in view : UIView? = nil) -> Bool{
        if let _view = view,
            let _ = self.gifLoaders[_view]{
            return true
        }
        if let window = AppDelegate.shared.window,
            let _ = self.gifLoaders[window]{
            return true
        }
        return false
    }
}



