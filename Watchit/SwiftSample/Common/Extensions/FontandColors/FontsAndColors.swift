import Foundation
import UIKit
import MobileCoreServices

let ThemeColors : JSON? = infoPlist?.value(for: .ThemeColors)



class Fonts:NSObject{
    static let CIRCULAR_BOLD = "Apple Symbols"
    static let CIRCULAR_LIGHT = "Apple Symbols"
    static let CIRCULAR_BOOK = "Apple Symbols"
    static let MAKENT_LOGO_FONT1 = "makent1"
    static let MAKENT_LOGO_FONT2 = "makent2"
    static let MAKENT_LOGO_FONT3 = "makent3"
    static let MAKENT_AMENITIES_FONT = "makent-amenities"
}

enum CustomFont {
    case bold(size:CGFloat)
    case light(size:CGFloat)
    case medium(size:CGFloat)
    case logo(size:CGFloat)
    
    var instance:UIFont {
        switch self {
        case .bold(size: let size):
            return UIFont(name: Fonts.CIRCULAR_BOLD, size: size)!
        case .light(size: let size):
            return UIFont(name: Fonts.CIRCULAR_LIGHT, size: size)!
        case .medium(size: let size):
            return UIFont(name: Fonts.CIRCULAR_BOOK, size: size)!
            
        case .logo(size: let size):
            return UIFont(name: Fonts.MAKENT_LOGO_FONT1, size: size)!
        }
    }

}
extension CGFloat {
    static let EXTRALARGE :CGFloat = 52
    static let LARGE :CGFloat = 35
    static let HEADER:CGFloat = 20
    static let SUBHEADER:CGFloat = 16
    static let BODY:CGFloat = 14
    static let SMALL:CGFloat = 12
    static let TINY:CGFloat = 10
}


extension UIColor {
    static var appGuestThemeColor = Shared.guestThemeColor
    static var appHostThemeColor = Shared.hostThemeColor
}


extension UIColor {

    private static var _Colors = [String : UIColor]()

    public class var GuestThemeColor : UIColor {
        get { return UIColor._Colors["GuestThemeColor"] ?? UIColor(hex: ThemeColors?.string("GuestThemeColor")) }
        set { UIColor._Colors["GuestThemeColor"] = newValue } }

    public class var HostThemeColor : UIColor {
        get { return UIColor._Colors["HostThemeColor"] ?? UIColor(hex: ThemeColors?.string("HostThemeColor")) }
        set { UIColor._Colors["HostThemeColor"] = newValue } }

    public class var GuestDarkThemeColor : UIColor { return UIColor(hex: ThemeColors?.string("GuestDarkThemeColor")) }

    public class var CovidSheildColor : UIColor { return UIColor(hex: ThemeColors?.string("CovidSheildColor")) }

    public class var FavoriteColor: UIColor { return UIColor(hex: ThemeColors?.string("FavoriteColor")) }

    public class var LightFavoriteColor: UIColor { return UIColor(hex: ThemeColors?.string("FavoriteColor")).withAlphaComponent(0.5) }

    public class var InstantBookColor : UIColor { return UIColor(hex: ThemeColors?.string("InstantBookColor")) }
    
    
    //MARK: hex Extention
    public  convenience init(hex : String?) {
        guard let hex = hex else {
            self.init()
            return }

        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(red: 1, green: 1, blue: 1, alpha: 1)
            return
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
