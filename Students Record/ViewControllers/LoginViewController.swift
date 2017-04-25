//
//  LoginViewController.swift
//  Students Record
//
//  Created by JK on 25/04/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextFiled: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
        if (user != nil) {
            
        } else {
            
        }
     })
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
    
//     MARK: - IBactions

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        var errMsg : String = ""
        
        if (emailTextfield.text?.isEmpty)! || (passwordTextFiled.text?.isEmpty)! {
            
            print("\(emailTextfield.text ?? "") \(passwordTextFiled.text ?? "")" )
            errMsg = "Empty email or password"
        } else if isValidEmail(testStr: emailTextfield.text!) {
            errMsg = "Invalid Email"
        }
        
        if !errMsg.isEmpty {
            
            print("\(errMsg)")
        }
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
