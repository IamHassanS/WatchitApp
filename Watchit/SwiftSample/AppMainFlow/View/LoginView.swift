
import Foundation
import UIKit
import GoogleSignIn

class LoginVIew: BaseView {
    

    // MARK: - Outlets
    
    @IBOutlet weak var noconnectionView: UIView!
    //MARK: Common
    @IBOutlet weak var backHolderView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var contentHolderVIew: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var facebookview: UIView!
    @IBOutlet weak var passwordValidationLbl: UILabel!
    @IBOutlet weak var signUpbtn: UIButton!
    @IBOutlet weak var signinLbl: UILabel!
    @IBOutlet weak var welcombackLbl: UILabel!
    
    @IBOutlet weak var appLogoIV: UIView!
    
    @IBOutlet weak var contentScrollview: UIScrollView!
    
    //MARK: - OTP Flow Signup
    @IBOutlet weak var mobileStack: UIStackView!
    @IBOutlet weak var phoneCodeView: UIView!
    @IBOutlet weak var phoneCodeLbl: UILabel!
    @IBOutlet weak var orView: UIView!
    @IBOutlet weak var signUpEmailTF: UITextField!
    @IBOutlet weak var mobileSubPhoneView: UIView!
    @IBOutlet weak var mobileSubEmailView: UIView!
    @IBOutlet weak var phoneNumberFld: UITextField!
    
    //MARK: - LOGIN FLOW
    @IBOutlet weak var credentialsStack: UIStackView!
    @IBOutlet weak var loginEmailorUsernameView: UIView!
    @IBOutlet weak var loginPasswordView: UIView!
    @IBOutlet weak var shoeHidePasswordView: UIView!
    @IBOutlet weak var showPasswordHolderIV: UIImageView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var closeholderView: UIView!
    
    @IBOutlet weak var serviceTilePageControl: UIPageControl!
    
    //MARK: - Collection VIew
    @IBOutlet weak var collectionViewExplore: UICollectionView!
    
  
    // MARK: - Properties

    var loginVc: LoginVC!
    var isPasswoordVerified = false
    var isEmailVerified = false
    var isMobileVerifed = false
    var isSignupEmailVerified = false
    var isShowViewModified = Bool()
    var isHideViewModified = Bool()
    var pageType : pageType = .login
    var userState = Bool()
    var email = ""
    
    let network: ReachabilityManager = ReachabilityManager.sharedInstance
    var data = [String]()
    private var indexOfCellBeforeDragging = 0
    var index: Int = 0
    lazy var toolBar : UIToolbar = {
        let tool = UIToolbar(frame: CGRect(origin: CGPoint.zero,
                                              size: CGSize(width: self.frame.width,
                                                           height: 30)))
        let done = UIBarButtonItem(barButtonSystemItem: .done,
                                   target: self,
                                   action: #selector(self.doneAction))
        tool.setItems([done], animated: true)
        tool.sizeToFit()
        return tool
    }()
    
    
    //MARK: - View LIfe cycle
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.loginVc = baseVC as? LoginVC
        initData()
        setupUI()
        cellregistration()
        toLOadData()
        initNotifcations()
       
    }
    override func didLayoutSubviews(baseVC: BaseViewController) {
        self.collectionViewExplore.layoutIfNeeded()
       // self.collectionViewExplore.centerContentHorizontalyByInsetIfNeeded(minimumInset: UIEdgeInsets.init(top: 8, left: 15, bottom: 8, right: 15))
    }

    
    
    func toLOadData() {
        for i in 0...2 {
            data.append("\(i)")
        }
        self.collectionViewExplore.dataSource = self
        self.collectionViewExplore.delegate = self
        self.collectionViewExplore.reloadData()
        if self.data.count > 2 {
            let indexPath = IndexPath(row: 1, section: 0)
            collectionViewExplore.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            serviceTilePageControl.numberOfPages = self.data.count
        }
    }
    
    func cellregistration() {
        self.collectionViewExplore.register(UINib.init(nibName: "LoginImageCVC", bundle: nil), forCellWithReuseIdentifier: "LoginImageCVC")
    }
    
    
    // MARK: - set pagination for collection view
    private func calculateSectionInset() -> CGFloat {
        let deviceIsIpad = UIDevice.current.userInterfaceIdiom == .pad
        let deviceOrientationIsLandscape = UIDevice.current.orientation.isLandscape
        let cellBodyViewIsExpended = deviceIsIpad || deviceOrientationIsLandscape
        let cellBodyWidth: CGFloat =  (self.collectionViewExplore.frame.size.width/1.12) + (cellBodyViewIsExpended ? 174 : 0)
        
   //     let buttonWidth: CGFloat = 50
        
        let inset = (collectionViewExplore.frame.width - cellBodyWidth) / 5
        return inset
    }
    
    private func indexOfMajorCell() -> Int {
        
        let inset: CGFloat =  calculateSectionInset()
        let itemWidth = (self.collectionViewExplore.frame.size.width/1.12) - inset * 2
        //
        let proportionalOffset = collectionViewExplore.contentOffset.x / itemWidth
        //let index = Int(round(proportionalOffset))
  
        var index: Int = 0
    
      
           // proportionalOffset = proportionalOffset - 0.5
     
            index = Int(proportionalOffset.rounded(.up))
      
       
        let safeIndex = max(0, min(data.count - 1, index))
        return safeIndex
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let collect = scrollView as? UICollectionView {
            if collect == self.collectionViewExplore {
               // self.isForCategory = false
                indexOfCellBeforeDragging = indexOfMajorCell()
            }
        }
    }
        
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == scrollView as? UICollectionView {
            if scrollView == self.collectionViewExplore {
                // Stop scrollView sliding:
                targetContentOffset.pointee = scrollView.contentOffset
                
                // calculate where scrollView should snap to:
                let indexOfMajorCell = self.indexOfMajorCell()
                
                // calculate conditions:
                let swipeVelocityThreshold: CGFloat = 1 // after some trail and error
                let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < data.count && velocity.x > swipeVelocityThreshold
                if indexOfCellBeforeDragging == 12 {
                    
                }
                let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
                let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
                let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
                
                if didUseSwipeToSkipCell {
                    
                    let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
                    let inset: CGFloat = calculateSectionInset()
                    let itemWidth =  collectionViewExplore.frame.size.width - inset * 2
                    let toValue = itemWidth * CGFloat(snapToIndex)
                    
                    print(snapToIndex)
                    let indexPath = IndexPath(row: snapToIndex, section: 0)
                    self.collectionViewExplore.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    
                    // Damping equal 1 => no oscillations => decay animation:
                    //                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                    //                        scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                    //                        scrollView.layoutIfNeeded()
                    //                    }, completion: nil)
                    
                } else {
                    // This is a much better way to scroll to a cell:
                    
                    //  index = index + 1
                    let celltoScroll: Int = indexOfMajorCell
                    // print(exploreData.data[celltoScroll])
                    let indexPath = IndexPath(row: celltoScroll, section: 0)
                    self.collectionViewExplore.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
    
    // MARK: - Functionalities for Setting up view UI
    
    func setupUI() {
        if let layout = self.collectionViewExplore.collectionViewLayout as? UICollectionViewFlowLayout {

            layout.scrollDirection = .horizontal

        }
        self.collectionViewExplore.showsHorizontalScrollIndicator = false
        appLogoIV.elevate(4)
        appLogoIV.layer.cornerRadius = 20
        closeholderView.elevate(4)
        closeholderView.layer.cornerRadius = closeholderView.height / 2
        googleView.elevate(4)
        appleView.elevate(4)
        facebookview.elevate(4)
        loginPasswordView.layer.cornerRadius =  loginPasswordView.height / 2
        loginPasswordView.elevate(4)
        loginEmailorUsernameView.layer.cornerRadius =  loginPasswordView.height / 2
        loginEmailorUsernameView.elevate(4)
        mobileSubEmailView.elevate(4)
        mobileSubEmailView.layer.cornerRadius =  loginPasswordView.height / 2
        mobileSubPhoneView.elevate(4)
        mobileSubPhoneView.layer.cornerRadius =  loginPasswordView.height / 2
        if  Shared.instance.selectedPhoneCode.isEmpty {
            self.phoneCodeLbl.text = "+91"
        } else {
            self.phoneCodeLbl.text = Shared.instance.selectedPhoneCode
        }
        checkButtonStatus(true)
        passwordValidationLbl.isHidden = true
        signUpbtn.elevate(4)
        signUpbtn.layer.cornerRadius = signUpbtn.height / 2
   
        mobileStack.isUserInteractionEnabled = true
        topView.setSpecificCornersForBottom(cornerRadius: 25)
        NotificationCenter.default.addObserver(self, selector: #selector(networkModified(_:)) , name: NSNotification.Name("connectionChanged"), object: nil)
        let connectivity =  LocalStorage.shared.getString(key: .connectivity)
          if connectivity == "No Connection" {
              self.toSetPageType(.notconnected)
          } else {
              self.toSetPageType(.connected)
          }
    }
    
    @objc func networkModified(_ notification: NSNotification) {
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
               if let status = dict["Type"] as? String{
                   DispatchQueue.main.async {
                       if status == "No Connection" {
                           self.toSetPageType(.notconnected)
                       } else {
                           
                           self.toSetPageType(.connected)
                       }

                   }
               }
           }
    }
    
    
    func toSetPageType(_ isconnected: Connectivity) {
        switch isconnected {
        case .connected:
            self.contentScrollview.isHidden = false
            self.noconnectionView.isHidden = true
        case .notconnected:
            self.contentScrollview.isHidden = true
            self.noconnectionView.isHidden = false
        case .nowishList:
            break
        }
        
    }
    
    // MARK: - Functionalities for Setting up pagetypes
    
    enum pageType {
        case login
        case signup
        case email
        case phone
        case def
        
    }
    
    func setPagetype(pageType: pageType) {
        switch pageType {
        case .login:
            self.pageType = .login
            self.mobileStack.isHidden = true
            self.credentialsStack.isHidden = false
            signUpbtn.setTitle("Login", for: .normal)
            self.passwordValidationLbl.text = "Password should be alphanumeric, special character, min 8 char & max16, combination upper case."
            welcombackLbl.text = "Sign in with Google / Credentials"
            self.signinLbl.isHidden = false
            self.signinLbl.text = "Sign up with mobile"
            self.backHolderView.isHidden = true
           // self.emailTF.becomeFirstResponder()
            
        case .signup:
            welcombackLbl.text = "Signup"
            self.pageType = .signup
            self.mobileStack.isHidden = false
            self.credentialsStack.isHidden = true
//            mobileSubEmailView.isHidden = false
//            mobileSubPhoneView.isHidden = false
//            orView.isHidden = false
            signUpbtn.setTitle("Send OTP", for: .normal)
            backHolderView.isHidden = true
           
        case .email:
            self.pageType = .email
            self.mobileStack.isHidden = false
            self.credentialsStack.isHidden = true
            mobileSubEmailView.isHidden = false
            mobileSubPhoneView.isHidden = true
            self.passwordValidationLbl.text = "Enter valid Email"
            signUpbtn.setTitle("Send OTP", for: .normal)
            orView.isHidden = true
            self.signinLbl.text = "Already have an Account? then sign in."
          //  backHolderView.isHidden = false
            backHolderView.isHidden = true
            self.signUpEmailTF.becomeFirstResponder()
        case .phone:
            self.pageType = .phone
            self.mobileStack.isHidden = false
            self.credentialsStack.isHidden = true
            mobileSubEmailView.isHidden = true
            mobileSubPhoneView.isHidden = false
            orView.isHidden = true
            self.passwordValidationLbl.text = "Enter valid Mobile number"
            signUpbtn.setTitle("Send OTP", for: .normal)
            self.signinLbl.text = "Already have an Account? then sign in."
            self.phoneNumberFld.becomeFirstResponder()
            backHolderView.isHidden = true
         //   backHolderView.isHidden = false
        case .def:
            self.pageType = .signup
            self.mobileStack.isHidden = false
            self.credentialsStack.isHidden = true
            mobileSubEmailView.isHidden = false
            mobileSubPhoneView.isHidden = false
            orView.isHidden = false
            signUpbtn.setTitle("Send OTP", for: .normal)
            backHolderView.isHidden = true
        }
    }
    
    @objc func doneAction(){
        isHideViewModified = false
        isShowViewModified = false
        self.endEditing(true)
        self.checkButtonStatus(false)
    }
    
    func  initData(){
        emailTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        phoneNumberFld.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        signUpEmailTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTF.delegate = self
        passwordTF.delegate = self
        phoneNumberFld.delegate = self
        signUpEmailTF.delegate = self
        phoneNumberFld.keyboardType = .numberPad
        setToolBar(self.toolBar)
        let state = !LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserLoggedin)
        self.userState = state
        signinLbl.isHidden = state
        self.setPagetype(pageType: state == true ? .login : .signup)
        signinLbl.addTap {
            self.setPagetype(pageType: self.pageType == .login ? .signup : .login)
            self.signinLbl.text = self.pageType == .login ? "Sign up with mobile" : "Already have an Account? then sign in."
            self.passwordValidationLbl.text = ""
        }
        
        closeholderView.addTap {
            self.loginVc.sceneDelegate?.setTabbarForSwithUsers()
        }
        

        phoneCodeView.addTap {
         
        }
        phoneNumberFld.addTap {
            self.setPagetype(pageType: .phone)
        }
        signUpEmailTF.addTap {
            self.setPagetype(pageType: .email)
        }
        
        backHolderView.addTap {
            self.setPagetype(pageType: .def)
        }
        shoeHidePasswordView.addTap {
            self.showPasswordHolderIV.image =  self.showPasswordHolderIV.image == UIImage(systemName: "eye") ?  UIImage(systemName: "eye.slash.fill") : UIImage(systemName: "eye")
            self.passwordTF.isSecureTextEntry = self.showPasswordHolderIV.image == UIImage(systemName: "eye.slash.fill") ? true : false
            
        }
        googleView.addTap {
            self.doGoogleLogin()
        }
        appleView.addTap {
            
        }

    }

    func setToolBar(_ bar : UIToolbar){
        self.phoneNumberFld.inputAccessoryView = bar
        self.emailTF.inputAccessoryView = bar
        passwordTF.inputAccessoryView = bar
        signUpEmailTF.inputAccessoryView = bar
    }
    
    
    func initNotifcations() {
 

        
    }
    
    deinit {
     //   NotificationEnum.removeobserver.removeAll(self)
    }
    
   
    @IBAction func didTapLoginBtn(_ sender: Any) {
        
        if self.pageType == .login {
            // !userState &&
          //  Shared.instance.showLoader(in: self)
            let email = self.emailTF.text!
            let password = self.passwordTF.text!
            self.loginVc.sceneDelegate?.generateTabbarController()
//            ExploreVC.initWithStory()
//            vc.hidesBottomBarWhenPushed = true
//            self.loginVc.navigationController?.pushViewController(vc, animated: true)
            
            }
        else if self.pageType == .signup || self.pageType == .phone  {
            let commonAlert = CommonAlert()
            commonAlert.setupAlert(alert: "Watchit", alertDescription: "Hello user otp will be sent to given mobile number", okAction: "Ok",cancelAction: "Cancel")
            commonAlert.addAdditionalOkAction(isForSingleOption: false) {
                print("no action")
                self.callOTPPage()
            }
            commonAlert.addAdditionalCancelAction {
                print("yes action")
            }
        }


    }
    
    func callOTPPage() {

    }
    
    
    

    
    @IBAction
    private func textFieldDidChange(textField: UITextField) {
        if self.pageType == .login {
            if textField == self.emailTF {
                guard let email = textField.text, !email.isEmpty else {
                    
                    return}
                if email.isValidMail {
                    isEmailVerified = true
                    passwordValidationLbl.isHidden = true
                    passwordValidationLbl.text = ""
                    checkButtonStatus(false)
                } else {
                  //  self.loginVc.sceneDelegate?.createToastMessage("Enter Valid Email", isFromWishList: true)
                    passwordValidationLbl.isHidden = false
                    passwordValidationLbl.text = "Please enter valid email"
                    isEmailVerified = false
                    checkButtonStatus(false)
                }
                
            }
            else if textField == self.passwordTF {
                guard let passwd = textField.text, !passwd.isEmpty else {
                    
                    return}
                if passwd.count>7 && passwd.containsSpecialCharacter {
                    self.isPasswoordVerified = true
                    passwordValidationLbl.isHidden = true
                    checkButtonStatus(false)
                } else {
                    // self.loginVc.sceneDelegate?.createToastMessage("Enter Valid password")
                    passwordValidationLbl.isHidden = false
                    passwordValidationLbl.text = "Password should be alphanumeric, special character, min 8 char & max16, combination upper case."
                    self.isPasswoordVerified = false
                    checkButtonStatus(false)
                }
                
            }
        } else {
            if textField == self.phoneNumberFld {
                guard let phonenumber = textField.text, !phonenumber.isEmpty else {
                    
                    return}
                if phonenumber.isValidPhoneNumber {
                    self.isMobileVerifed = true
                    passwordValidationLbl.isHidden = true
                    checkButtonStatus(false)
                } else {
                    self.isMobileVerifed = false
                    passwordValidationLbl.isHidden = false
                    checkButtonStatus(false)
                }
                
            } else if textField == self.signUpEmailTF {
                guard let email = textField.text, !email.isEmpty else {
                    
                    return}
                if email.isValidMail {
                    self.isSignupEmailVerified = true
                    passwordValidationLbl.isHidden = true
                    checkButtonStatus(false)
                } else {
                    self.isSignupEmailVerified = false
                    passwordValidationLbl.isHidden = false
                    checkButtonStatus(false)
                }
                
            }
            
        }

    
}
    
}


extension LoginVIew: UITextFieldDelegate {
    func checkButtonStatus(_ isFirsttime: Bool) {
        if isFirsttime {
            signUpbtn.alpha = 0.5
            signUpbtn.isUserInteractionEnabled = false
        }  else if self.pageType == .login {
            if isEmailVerified &&  isPasswoordVerified {
                self.signUpbtn.alpha = 1
                self.signUpbtn.isUserInteractionEnabled = true
            } else {
                self.signUpbtn.alpha = 0.5
                self.signUpbtn.isUserInteractionEnabled = false
                
            }
        } else if self.pageType == .phone {
            if isMobileVerifed {
                self.signUpbtn.alpha = 1
                self.signUpbtn.isUserInteractionEnabled = true
            } else {
                self.signUpbtn.alpha = 0.5
                self.signUpbtn.isUserInteractionEnabled = false
            }
        } else  if self.pageType == .email {
            if isSignupEmailVerified {
                self.signUpbtn.alpha = 1
                self.signUpbtn.isUserInteractionEnabled = true
            } else {
                self.signUpbtn.alpha = 0.5
                self.signUpbtn.isUserInteractionEnabled = false
            }
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.pageType == .login {
            if textField == self.emailTF {
                self.resignFirstResponder()
                //  self.passwordTF.becomeFirstResponder()
                self.endEditing(true)
                
            } else if textField == self.passwordTF {
                self.endEditing(true)
                checkButtonStatus(false)
                
                self.resignFirstResponder()
                
            }
            isHideViewModified = false
            isShowViewModified = false
        } else {
            self.endEditing(true)
            self.resignFirstResponder()
            //    self.phoneNumberFld.becomeFirstResponder()
        }
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
    

}

extension LoginVIew {
    
    //MARK: Google Login
    func doGoogleLogin() {
        guard  let googlePlist = PlistReader<GooglePlistKeys>(),
               let clinetId : String = googlePlist.value(for: .clientId) else {
                   print("Google Client ID Missing")
                   return }
        SocialLoginsHandler.shared.doGoogleLogin(VC: self.loginVc,
                                                 clientID: clinetId) { result in
            switch result {
            case .success(let user):
                print("\(user.accessToken)")
                Global_UserProfile = UserProfileDataModel()
                if let userID = user.userID,
                   let profile = user.profile {
                    Global_UserProfile.firstName = profile.givenName ?? ""
                    Global_UserProfile.lastName =  profile.familyName ?? ""
                    Global_UserProfile.emailID = profile.email


                    let givenName = profile.givenName
                    let familyName = profile.familyName
                    let email = profile.email
                    var dicts = [String: Any]()
                    dicts["email"] = email
                    self.email = email
                    var imageStr = ""
                    var imageData = Data()
                    //self.loginVC.auth_type = "google"
                   // self.loginVC.auth_id = user.userID ?? ""
                    dicts["name"] = givenName! + familyName!
                    dicts["provider"] =  "google"
                    dicts["auth_type"] = "google"
                    dicts["auth_id"] = user.userID
                    if SocialLoginsHandler.shared.doGoogleHasProfile() {
                        let dimension = round(120 * UIScreen.main.scale)
                        let imageURL = profile.imageURL(withDimension: UInt(dimension))
                        dicts["avatar_original"] = imageURL?.absoluteString
                        Global_UserProfile.userImage = imageURL?.absoluteString ?? ""
                        imageStr = imageURL?.absoluteString ?? ""
                        do {
                            imageData = try NSData(contentsOf: URL.init(string: imageStr)!, options: NSData.ReadingOptions()) as Data
                } catch {
                    print("")
                }

                    }
//                    self.loginVC.checkSocialMediaId(userData: dicts,
//                                                           signUpType: .google(id: userID))
                    
                    let commonAlert = CommonAlert()
                    commonAlert.setupAlert(alert: "Watchit", alertDescription: "Welcome \(givenName!) \(familyName!)", okAction: "Ok", userImage: imageData)
                    commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                        print("Yes action")
                        LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserLoggedin, value: true)
                        LocalStorage.shared.setSting(LocalStorage.LocalValue.userName, text: "\(givenName!) \(familyName!)")
                        LocalStorage.shared.setSting(LocalStorage.LocalValue.userimageURl, text: "\(imageStr)")
                        self.loginVc?.sceneDelegate?.setLoginPage()
                       // LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserLoggedin)
                      
                    }
                    commonAlert.addAdditionalCancelAction {
                        self.loginVc?.sceneDelegate?.setLoginPage()
                        print("No action")
                      
                    }
                    
             

                } else {
                    print("Data Missing")
                }
            case .failure(let error):
                print(error)
                self.loginVc.sceneDelegate?.createToastMessage(error.localizedDescription, isFromWishList: true)
            }
        }
    }

}


        extension LoginVIew : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return data.count
            }
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
              
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoginImageCVC", for: indexPath) as! LoginImageCVC
                    
                   // cell.viewBg.elevate(4)
                cell.contentHolderView.elevate(4)
                cell.contentHolderView.layer.cornerRadius = 12
                cell.imageHolderVIew.layer.cornerRadius =  cell.imageHolderVIew.height / 2
                cell.imageIV.layer.cornerRadius =  cell.imageIV.height / 2
                cell.gradientView.setSpecificCornersForBottom(cornerRadius: 12)
               // cell.gradientView.setGradient()
                    return cell
              
            }
            
            func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
                   return CGSize.init(width: (self.collectionViewExplore.frame.size.width/1.12), height: collectionViewExplore.height - 10)
                   //288
                   //self.view.frame.size.height * 0.365
               
            }
            
            func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
                UIView.animate(withDuration: 0.5) {
                    if collectionView == self.collectionViewExplore{
                        if let cell = collectionView.cellForItem(at: indexPath) as? LoginImageCVC {
                            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                        }
                    }
                }
            }
            
            
            func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
                UIView.animate(withDuration: 0.5) {
                    if collectionView == self.collectionViewExplore{
                        if let cell = collectionView.cellForItem(at: indexPath) as? LoginImageCVC {
                            cell.transform = CGAffineTransform(scaleX: 1, y: 1)

                        }
                   }
                }
            }
            
            
        }


extension LoginVIew: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let collect = scrollView as? UICollectionView {
            if collect == self.collectionViewExplore {
                let visibleRect = CGRect(origin: self.collectionViewExplore.contentOffset, size: self.collectionViewExplore.bounds.size)
                let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                if let visibleIndexPath = self.collectionViewExplore.indexPathForItem(at: visiblePoint) {
                    self.serviceTilePageControl.currentPage = visibleIndexPath.row
                }
            }
        }
        
    }
}
