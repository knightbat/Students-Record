//
//  StudentDataViewController.swift
//  Students Record
//
//  Created by Bindu on 25/04/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit
import FirebaseDatabase

class StudentDataViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var studentsArray: [Any] = []
    
    let ref = FIRDatabase.database().reference().child("StudentList")
    @IBOutlet var studentTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true

    }
    override func viewWillAppear(_ animated: Bool) {
        ref.observeSingleEvent(of: .value, with: { snapshot in
            self.studentsArray = snapshot.children.allObjects
            self.studentTableView.reloadData()
        })

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -  UITableView DataSource and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : StudentDataTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sCell") as! StudentDataTableViewCell
        let studentData : FIRDataSnapshot = studentsArray[indexPath.row] as! FIRDataSnapshot
        cell.rollNumLabel.text = studentData.key
        let data : [String:String] = studentData.value as! [String : String];
        cell.nameLabel.text = data["name"]
        cell.ageLabel.text = data["age"]
        cell.markLabel.text = data["mark"]
        
        return cell
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
