//
//  LoginVC.swift
//  Watchit
//
//  Created by HASSAN on 03/08/23.
//

import UIKit
import MobileCoreServices
import AuthenticationServices

class LoginVC: BaseViewController {
    @IBOutlet var loginView: LoginVIew!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    class func initWithStory() -> LoginVC {
        let loginVC : LoginVC = UIStoryboard.AppMainFlow.instantiateViewController()
        return loginVC
    }

  

}


    
 


