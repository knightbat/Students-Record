//
//  DetailsViewController.swift
//  Students Record
//
//  Created by Bindu on 05/05/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DetailsViewController: UIViewController {

    var studentData : FIRDataSnapshot = FIRDataSnapshot()
    @IBOutlet var rollNumLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var markLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
            rollNumLabel.text = ": \(studentData.key)"
            let data : [String:Any] = studentData.value as! [String : Any];
            nameLabel.text = ": \(data["name"] ?? "")"
            ageLabel.text = ": \(data["age"] ?? "")"
            markLabel.text = ": \(data["mark"] ?? "")"
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
