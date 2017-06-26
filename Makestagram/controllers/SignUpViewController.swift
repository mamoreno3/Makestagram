//
//  SignUpViewController.swift
//  Makestagram
//
//  Created by Nguyễn Lâm on 6/23/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // create username in the database if the user is signing up
    @IBAction func signUpContinue(_ sender: Any) {
        guard let firUser = Auth.auth().currentUser,
        let username = usernameTextField.text,
        !username.isEmpty
        else {
            return
        }
        
        // create a dictionary to store the username from the text field
        let userAttrs = ["username": username]
        
        // create reference to the uid of the username in the database
        let ref = Database.database().reference().child("users").child(firUser.uid)
        // add the user to the database
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                let user = User(snapshot: snapshot)
                
                // handle the new user who just got created
            })
            
        }
    }

}
