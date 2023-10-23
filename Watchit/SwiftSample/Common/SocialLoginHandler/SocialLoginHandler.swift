//
//  SocialLoginHandler.swift
//  SocialLogins
//
//  Created by HASSAN on 25/10/21.
//

import Foundation
import GoogleSignIn
//import FBSDKLoginKit
import CloudKit
import UIKit

open
class SocialLoginsHandler : NSObject {

    //---------------------------------------------
    // MARK: - Shared Variable
    //---------------------------------------------

    public static let shared = SocialLoginsHandler()

    //---------------------------------------------
    // MARK: - Local Variable
    //---------------------------------------------

    //---------------------------------------------
    // MARK: - Google Login
    //---------------------------------------------

    public
    func handleGoogle(url: URL) -> Bool {
        let handled = GIDSignIn.sharedInstance.handle(url)
        return handled
    }

    public
    func doGoogleLogin(VC: UIViewController,
                       clientID : String,
                       completion: @escaping (Result<GIDGoogleUser,Error>) -> Void) {
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        //GIDSignIn.sharedInstance.
        GIDSignIn.sharedInstance.signIn(withPresenting: VC) { user, error in
            if error != nil || user == nil {
                guard let error = error else { return }
                completion(.failure(error))
            } else {
                guard let user = user else { return }
                completion(.success(user.user))
            }
        }
    }
    public
    func doGoogleHasProfile() -> Bool {
        guard let hasImage = GIDSignIn.sharedInstance.currentUser?.profile?.hasImage else { return false }
        return hasImage
    }

    public
    func doGoogleSignOut() {
        GIDSignIn.sharedInstance.signOut()
    }

    public
    func doGogleRelogin(completion: @escaping (Result<GIDGoogleUser,Error>) -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
                guard let error = error else { return }
                completion(.failure(error))
            } else {
                guard let user = user else { return }
                completion(.success(user))
                // Show the app's signed-in state.
            }
        }
    }

}
