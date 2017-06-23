//
//  LoginViewController.swift
//  Makestagram
//
//  Created by Nguyễn Lâm on 6/22/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    @IBOutlet weak var logInButton: UIButton!

    @IBAction func logIn(_ sender: UIButton) {
        print("login button touched")
        
        guard let authUI = FUIAuth.defaultAuthUI()
        else {
            return
        }
        
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// handle login
extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        // handle the error if users cant sign in
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
        }
        
        guard let user = user
        else {
            return
        }
        print("handle user signup/login")
        
        // read the data from the database, which is the user information
        let rootRef = Database.database().reference()
        let userRef = rootRef.child("users").child(user.uid)
        
        // determine if the data from the database is from old users or new users
        userRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let user = User(snapshot: snapshot) {
                print("old user, \(user.username)")
            } else {
                print("new user")
            }
        })
    }
}
