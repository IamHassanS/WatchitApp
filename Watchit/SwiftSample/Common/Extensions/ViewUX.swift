//
//  ViewUX.swift
//  Watchit
//
//  Created by HASSAN on 18/04/23.
//

import Foundation
import UIKit
import SDWebImage

private var AssociatedObjectHandle: UInt8 = 25
private var ButtonAssociatedObjectHandle: UInt8 = 10

extension UIView {
    

    
    var closureId:Int{
        get {
            let value = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Int ?? Int()
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    public enum closureActions : Int{
        case none = 0
        case tap = 1
        case swipe_left = 2
        case swipe_right = 3
        case swipe_down = 4
        case swipe_up = 5
    }
    
    public struct closure {
        typealias emptyCallback = ()->()
        static var actionDict = [Int:[closureActions : emptyCallback]]()
        static var btnActionDict = [Int:[String: emptyCallback]]()
    }
    
    public func addTap(Action action:@escaping() -> Void){
        self.actionHandleBlocks(.tap,action:action)
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(triggerTapActionHandleBlocks))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    public func actionHandleBlocks(_ type : closureActions = .none,action:(() -> Void)? = nil) {
        
        if type == .none{
            return
        }
        //        print("∑type : ",type)
        var actionDict : [closureActions : closure.emptyCallback]
        if self.closureId == Int(){
            self.closureId = closure.actionDict.count + 1
            closure.actionDict[self.closureId] = [:]
        }
        if action != nil {
            actionDict = closure.actionDict[self.closureId]!
            actionDict[type] = action
            closure.actionDict[self.closureId] = actionDict
        } else {
            let valueForId = closure.actionDict[self.closureId]
            if let exe = valueForId![type]{
                exe()
            }
        }
    }
    
    @objc public func triggerTapActionHandleBlocks() {
        self.actionHandleBlocks(.tap)
    }
    @objc public func triggerSwipeLeftActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_left)
    }
    @objc public func triggerSwipeRightActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_right)
    }
    @objc public func triggerSwipeUpActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_up)
    }
    @objc public func triggerSwipeDownActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_down)
    }
    
    open
    func addAction(for type: closureActions ,
                   Action action:@escaping() -> Void) {
        self.isUserInteractionEnabled = true
        self.actionHandleBlocks(type,action:action)
        switch type{
        case .none:
            return
        case .tap:
            let gesture = UITapGestureRecognizer()
            gesture.addTarget(self,
                              action: #selector(triggerTapActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_left:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.left
            gesture.addTarget(self,
                              action: #selector(triggerSwipeLeftActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_right:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.right
            gesture.addTarget(self,
                              action: #selector(triggerSwipeRightActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_up:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.up
            gesture.addTarget(self,
                              action: #selector(triggerSwipeUpActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_down:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.down
            gesture.addTarget(self,
                              action: #selector(triggerSwipeDownActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        }
    }
}



extension UIView {
    public var width: CGFloat {
        return frame.size.width
    }
    public var height: CGFloat {
        return frame.size.height
    }
    public var top: CGFloat {
        return frame.origin.y
    }
    public var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }
    public var left: CGFloat {
        return frame.origin.x
    }
    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }
}


extension UIView {
    
    var cornerRadius : CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    /// Note : - Variable used For Set Border Width Alone in all Views
    var borderWidth : CGFloat {
        get { return layer.borderWidth }
        set {
            layer.borderWidth = newValue
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    /// Note : - Variable used For Set Border Color Alone in all Views
    var borderColor : UIColor? {
        get { return UIColor(cgColor: self.layer.shadowColor!) }
        set {
            layer.borderColor = newValue?.cgColor
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    func elevate(_ elevation: Double,
                 shadowColor : UIColor = .gray,
                 opacity : Float = 0.3) {
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: elevation)
        self.layer.shadowRadius = abs(elevation > 0 ? CGFloat(elevation) : -CGFloat(elevation))
        self.layer.shadowOpacity = opacity
    }
    
    func setSpecificCornersForTop(cornerRadius : CGFloat)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively

    }
    
    
    //layerMinXMinYCorner    top left corner
    //layerMaxXMinYCorner    top right corner
    //layerMinXMaxYCorner    bottom left corner
    //layerMaxXMaxYCorner    bottom right corner
    
    func setSpecificCornersForLeft(cornerRadius : CGFloat)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func setSpecificCornersForBottom(cornerRadius : CGFloat)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    func setSpecificCorners()
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
    }
    func removeSpecificCorner(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 0
        self.layer.maskedCorners = [] //
    }
}

extension UIView {
    func addTapIntraction(Intraction: Bool,Action action:@escaping() -> Void){
        self.actionHandleBlocks(.tap,action:action)
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(triggerTapActionHandleBlocks))
        self.isUserInteractionEnabled = Intraction
        self.addGestureRecognizer(gesture)
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           layer.mask = mask
       }
}


extension UIViewController {
    func presentInFullScreen(_ viewController: UIViewController,
                             animated: Bool,
                             completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
            viewController.modalPresentationStyle = .overCurrentContext
        } else {
            // Fallback on earlier versions
        }
        
        //    viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: animated, completion: completion)
    }
}

extension UIImage {
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)]).withRenderingMode(.alwaysTemplate)
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame.withRenderingMode(.alwaysTemplate))
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 3750)
        
        return animation
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a == b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    


    
}

extension UIImageView {
    func setImageWithHeaders(_ url: String) {
        let imageUrl = URL(string: url)!

        // Create custom headers as a dictionary
 

        // Set the custom headers for the image request
        SDWebImageDownloader.shared.setValue(LocalStorage.shared.getString(key: .accessToken), forHTTPHeaderField: "Authorization")
        SDWebImageDownloader.shared.setValue("application/json", forHTTPHeaderField: "Accept")

        // Use SDWebImage to load the image with the custom headers
        self.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "noImageThumb"))
    }
}
extension UIView{
    func shake(_ completion : @escaping ()->()){
        let translationY : CGFloat = self.frame.width * 0.065
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.calculationModeLinear], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                self.transform =  CGAffineTransform(translationX: 0, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                self.transform = CGAffineTransform(translationX: -translationY, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2, animations: {
                self.transform = CGAffineTransform(translationX: translationY, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2, animations: {
                self.transform = CGAffineTransform(translationX: -translationY, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.1, animations: {
                self.transform = CGAffineTransform(translationX: translationY, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
                self.transform =  .identity
            })
        }) { (completed) in
            if completed{
                completion()
            }
        }
    }
}
extension UIView{
    func freeze(for time : DispatchTime = .now() + 2){
        guard self.isUserInteractionEnabled else{return}
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: time) { [weak self] in
            self?.isUserInteractionEnabled = true
        }
    }
    
    func setGradient() {
      //  var gradientView = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors =
        [UIColor.white.cgColor,UIColor.black.withAlphaComponent(0.5).cgColor]
       //Use diffrent colors
        self.layer.addSublayer(gradientLayer)
    }
}



// UIViewController.swift
extension UIViewController: ReusableView { }

// UIStoryboard.swift
extension UIStoryboard {
    
    static var Main : UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
    

    static var AppMainFlow : UIStoryboard{
        return UIStoryboard(name: "AppMainFlow", bundle: nil)
    }
    

    func instantiateViewController<T>() -> T where T: ReusableView {
        return instantiateViewController(withIdentifier: T.reuseIdentifier) as! T
    }
    /**

     */
    func instantiateIDViewController<T>() -> T where T: ReusableView {
        return instantiateViewController(withIdentifier: T.reuseIdentifier + "ID") as! T
    }
}


//MARK:- Extensions
protocol ReusableView: AnyObject {}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
  
}
extension UIView {
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
extension ReusableView where Self : UIView {
     static func nib() -> UINib {
        return UINib(nibName: self.reuseIdentifier, bundle: nil)
    }
    static func getViewFromXib<T: ReusableView>() -> T?{
        return self.nib().instantiate(withOwner: nil, options: nil).first as? T
    }

    func setupFromNib<T: ReusableView & UIView>(_ object : T) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.02) {
            guard let view : T = Self.getViewFromXib(),
                !object.subviews.compactMap({$0.tag}).contains(2523143) else { fatalError("Error loading \(self) from nib") }
            view.tag = 2523143
            view.frame = object.bounds
            view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            object.addSubview(view)
            object.bringSubviewToFront(view)
      }
       
    }
}

extension String {
    var containsSpecialCharacter: Bool {
        let regex = "^(?=.*[a-z])(?=."
        + "*[A-Z])(?=.*\\d)"
        + "(?=.*[-+_!@#$%^&*., ?]).+$"
        let testString = NSPredicate(format:"SELF MATCHES %@", regex)
        return testString.evaluate(with: self)
    }
    
    
    var isValidMail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        let phoneRegEx = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: self)
    }
    
    func isValiduserName(Input:String) -> Bool {
        let RegEx = "\\w{1,18}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    
}
