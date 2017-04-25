//
//  AddDetailsViewController.swift
//  Students Record
//
//  Created by Bindu on 25/04/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddDetailsViewController: UIViewController {
    
    @IBOutlet var markLabel: UITextField!
    @IBOutlet var ageLabel: UITextField!
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var rollnumLabel: UITextField!
    
    let ref = FIRDatabase.database().reference(withPath:"StudentList")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveClicked(_ sender: UIButton) {
        
       let studentRef = ref.child(rollnumLabel.text!)
        studentRef.setValue([
            "name":nameLabel.text,
            "age":ageLabel.text,
            "mark":markLabel.text
            ])
        _ = self.navigationController?.popViewController(animated: true)
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
