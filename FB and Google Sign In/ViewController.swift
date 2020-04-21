//
//  ViewController.swift
//  FB and Google Sign In
//
//  Created by AshutoshD on 20/04/20.
//  Copyright © 2020 ravindraB. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate,GIDSignInUIDelegate {
  
    

    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    
    

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFb.layer.cornerRadius = 10
        btnFb.clipsToBounds = true
        
        btnGoogle.layer.cornerRadius = 10
        btnGoogle.clipsToBounds = true
      
    //    GIDSignIn.sharedInstance().uiDelegate = self
    }

    @IBAction func FbloginTapped(_ sender: Any) {
        
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }

        
    }
    
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
//                    print(result)
                    let resultDict  = result as! NSDictionary
                    print(resultDict)
                    
                    let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
                    profileVC?.FbDataDict = resultDict
                    profileVC?.flag = 1
                    self.navigationController?.pushViewController(profileVC!, animated: true)
//                    self.present(profileVC!, animated: false, completion: nil)
                }
            })
        }
    }
    
    @IBAction func GoogleLoginTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
   
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Google Sing In didSignInForUser")
        if error != nil {
            print(error.debugDescription)
            return
        }
        else  {
            if let user = user {
                let userModel = UserModelGoogle(name:user.profile.name, email: user.profile.email, userID: user.userID, ImgUrl: user.profile.imageURL(withDimension: UInt(200)))
                let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
                profileVC?.userModel = userModel
                profileVC?.flag = 2
//                self.present(profileVC!, animated: false, completion: nil)
                self.navigationController?.pushViewController(profileVC!, animated: true)
            }
        }
     
    }
//    // Start Google OAuth2 Authentication
//    func sign(_ signIn: GIDSignIn?, present viewController: UIViewController?) {
//
//        // Showing OAuth2 authentication window
//        if let aController = viewController {
//            present(aController, animated: true) {() -> Void in }
//        }
//    }
//    // After Google OAuth2 authentication
//    func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
//        // Close OAuth2 authentication window
//        dismiss(animated: true) {() -> Void in }
//    }
//
//}
}
