//
//  ProfileViewController.swift
//  FB and Google Sign In
//
//  Created by AshutoshD on 20/04/20.
//  Copyright © 2020 ravindraB. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var lblFname: UILabel!
    @IBOutlet weak var lblLname: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblUserID: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    let fbLoginManager : LoginManager = LoginManager()
    
    var userModel:UserModelGoogle?
    var FbDataDict = NSDictionary()
    var flag : Int = 0
     
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if flag  == 1 {
            self.title = "Facebook Signup"
            if !FbDataDict.allValues.isEmpty {
                lblFname.text = FbDataDict.value(forKey: "first_name") as! String
                lblLname.text = FbDataDict.value(forKey: "last_name") as! String
                lblEmail.text = FbDataDict.value(forKey: "email") as! String
                lblUserID.text = FbDataDict.value(forKey: "id") as! String
                let imag = FbDataDict.value(forKey: "picture") as! NSDictionary
                let imgURL = imag.value(forKey: "data") as! NSDictionary
                imgView.load(url: URL(string: imgURL.value(forKey: "url") as! String)!)
            }
            else {
                print("User Model not found")
            }
        }
        else if flag == 2 {
            self.title = "Google Signup"
            if let user = userModel {
                lblFname.text = user.name
                lblEmail.text = user.email
                lblUserID.text = user.userID
                imgView.load(url: user.ImgUrl!)
            }
            else {
                print("User Model not found")
            }
        }
        else {
            print("User Model not found")
        }
       
        
    }
    

    @IBAction func LogoutBtnTapped(_ sender: Any) {
        
        if flag == 1 {
            
            fbLoginManager.logOut()
            print("Facebook Logout")
            navigationController?.popViewController(animated: true)
        }
        else if flag == 2 {
            
            GIDSignIn.sharedInstance()?.signOut()
            print("Google Logout")
            navigationController?.popViewController(animated: true)
        }
    }
    

}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
