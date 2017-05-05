//
//  StudentDataViewController.swift
//  Students Record
//
//  Created by Bindu on 25/04/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit
import FirebaseDatabase
import ActionSheetPicker_3_0

class StudentDataViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var studentsArray: [Any] = []
    
    let ref = FIRDatabase.database().reference().child("StudentList")
    @IBOutlet var studentTableView: UITableView!
    @IBOutlet var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        activity.startAnimating()
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            self.studentsArray = snapshot.children.allObjects
            self.studentTableView.reloadData()
            self.activity.stopAnimating()
        })
        
    }
    @IBAction func sortClicked(_ sender: UIButton) {
        
        let array = ["by name","by mark","by age"]
        ActionSheetStringPicker.show(withTitle: "Sort", rows:array , initialSelection: 0, doneBlock: {
            picker, indexes, values in
            
            var param:String = ""
            
            if indexes == 0 {
                param = "name"
            } else if indexes == 1 {
                 param = "age"
            } else {
                 param = "mark"
            }
            
            (self.ref).queryOrdered(byChild: param).observeSingleEvent(of: .value, with: { snapshot in
                self.studentsArray = snapshot.children.allObjects
                self.studentTableView.reloadData()
                self.activity.stopAnimating()
            })
            self.studentTableView.reloadData()
            
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
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
        let data : [String:Any] = studentData.value as! [String : Any];
        cell.nameLabel.text = data["name"] as? String
        cell.ageLabel.text = data["age"] as? String
        cell.markLabel.text = data["mark"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let studentData : FIRDataSnapshot = studentsArray[indexPath.row] as! FIRDataSnapshot
            
            let studentRef = ref.child(studentData.key)
            studentRef.removeValue()
            studentsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier=="details") {
            let vc : DetailsViewController = segue.destination as! DetailsViewController
            let indexPath = studentTableView.indexPathForSelectedRow;
            let studentData : FIRDataSnapshot = studentsArray[indexPath!.row] as! FIRDataSnapshot
            vc.studentData = studentData
        }
    }
    
}
