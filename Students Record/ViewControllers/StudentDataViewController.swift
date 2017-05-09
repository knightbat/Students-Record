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
    
    @IBOutlet var emptyLabel: UILabel!
    @IBOutlet var popupView: UIView!
    let ref = FIRDatabase.database().reference().child("StudentList")
    var arrayCount = 0
    
    @IBOutlet var studentTableView: UITableView!
    @IBOutlet var activity: UIActivityIndicatorView!
    
    @IBOutlet var searchTextField: UITextField!
    
    @IBOutlet var innerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        popupView.isHidden = true
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        activity.startAnimating()
        emptyLabel.text = ""
        getData()
    }
    // MARK: -Methods
    
    func getData()  {
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            self.studentsArray = snapshot.children.allObjects
            
            if (self.studentsArray.count == 0) {
                self.emptyLabel.text = "No Data"
            } else {
                self.studentTableView.reloadData()
                self.arrayCount = self.studentsArray.count
                self.emptyLabel.text = ""
            }
            self.activity.stopAnimating()
        })
        
    }
    
    func search (searchText: String) {
        
        self.ref.queryOrdered(byChild: "name").queryEqual(toValue: searchText).observeSingleEvent(of: .value, with: { snapshot in
            self.studentsArray = snapshot.children.allObjects
            
            if self.studentsArray.count == 0 {
                
                self.ref.queryOrdered(byChild: "age").queryEqual(toValue: searchText).observeSingleEvent(of: .value, with: { snapshot in
                    
                    self.studentsArray = snapshot.children.allObjects
                    
                    if self.studentsArray.count == 0 {
                        
                        self.ref.queryOrdered(byChild: "mark").queryEqual(toValue: searchText).observeSingleEvent(of: .value, with: { snapshot in
                            
                             self.studentsArray = snapshot.children.allObjects
                            if self.studentsArray.count == 0 {
                                
                                self.ref.queryOrderedByKey().queryEqual(toValue: searchText).observeSingleEvent(of: .value, with: { snapshot in
                                    
                                     self.studentsArray = snapshot.children.allObjects
                                    if self.studentsArray.count == 0 {
                                        self.emptyLabel.text = "No Data"
                                    } else {
                                        self.emptyLabel.text = ""
                                    }
                                    self.studentTableView.reloadData()
                                })
                            } else {
                                self.studentTableView.reloadData()
                                self.emptyLabel.text = ""
                            }
                        })
                    } else {
                        self.studentTableView.reloadData()
                        self.emptyLabel.text = ""
                    }
                })
            } else {
                self.studentTableView.reloadData()
                self.emptyLabel.text = ""
            }
        })
        
    }
    
    // MARK: -UIButton Actions
    @IBAction func filterClicked(_ sender: UIButton) {
        
        self.view.bringSubview(toFront: popupView)
        popupView.isHidden = false
    }
    
    @IBAction func sortClicked(_ sender: UIButton) {
        
        let array = ["by name","by age","by mark"]
        ActionSheetStringPicker.show(withTitle: "Sort", rows:array , initialSelection: 0, doneBlock: {
            picker, indexes, values in
            
            self.activity.startAnimating()
            
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
            
        }, cancel: { ActionMultipleStringCancelBlock in return },
           origin: sender)
    }
    
    //    @IBAction func limitedToEndingClicked(_ sender: Any) {
    //
    //        self.ref.queryOrdered(byChild: "name").queryEnding(atValue: "bindu").observeSingleEvent(of: .value, with: { snapshot in
    //            self.studentsArray = snapshot.children.allObjects
    //            self.studentTableView.reloadData()
    //            self.activity.stopAnimating()
    //        })
    //        self.popupView.isHidden = true
    //
    //    }
    @IBAction func limitedToFirstClicked(_ sender: Any) {
        
        var array = Array<Any> ();
        for i in 1..<arrayCount {
            array.append("\(i) student(s)")
        }
        ActionSheetStringPicker.show(withTitle: "Filter", rows:array , initialSelection: 0, doneBlock: { picker, indexes, values in
            
            self.ref.queryLimited(toFirst: UInt(indexes+1)).observeSingleEvent(of: .value, with: { snapshot in
                self.studentsArray = snapshot.children.allObjects
                self.studentTableView.reloadData()
                self.activity.stopAnimating()
            })
            self.popupView.isHidden = true
            
        }, cancel: { ActionMultipleStringCancelBlock in return },
           origin: sender)
    }
    
    //    @IBAction func limitedToStartingClicked(_ sender: Any) {
    //
    //        self.ref.queryOrdered(byChild: "age").queryStarting(atValue: 26).observeSingleEvent(of: .value, with: { snapshot in
    //            self.studentsArray = snapshot.children.allObjects
    //            self.studentTableView.reloadData()
    //            self.activity.stopAnimating()
    //        })
    //        self.popupView.isHidden = true
    //
    //    }
    @IBAction func limitedToLastClicked(_ sender: Any) {
        
        var array = Array<Any> ();
        
        for  i in 1..<arrayCount-1 {
            array.append("\(i) student(s)")
        }
        ActionSheetStringPicker.show(withTitle: "Filter", rows:array , initialSelection: 0, doneBlock: { picker, indexes, values in
            
            self.ref.queryLimited(toLast: UInt(indexes+1)).observeSingleEvent(of: .value, with: { snapshot in
                self.studentsArray = snapshot.children.allObjects
                self.studentTableView.reloadData()
                self.activity.stopAnimating()
            })
            self.popupView.isHidden = true
        }, cancel: { ActionMultipleStringCancelBlock in return },
           origin: sender)
    }
    
    @IBAction func resetClicked(_ sender: Any) {
        
        activity.startAnimating()
        popupView.isHidden = true
        getData()
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        search(searchText: searchTextField.text!)
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        popupView.isHidden = true
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
