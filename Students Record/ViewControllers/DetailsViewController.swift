//
//  DetailsViewController.swift
//  Students Record
//
//  Created by Bindu on 05/05/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit

class DetailsViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var studentData : FIRDataSnapshot = FIRDataSnapshot()
    @IBOutlet var rollNumLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var markLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mapView.layer.cornerRadius = 3
        mapView.layer.borderColor = UIColor.black.cgColor
        mapView.layer.borderWidth = 1.5
        
        rollNumLabel.text = ": \(studentData.key)"
        let data : [String:Any] = studentData.value as! [String : Any];
        nameLabel.text = ": \(data["name"] ?? "")"
        ageLabel.text = ": \(data["age"] ?? "")"
        markLabel.text = ": \(data["mark"] ?? "")"
        
        
        let coord = CLLocationCoordinate2DMake(data["lat"] as! CLLocationDegrees, data["lng"] as! CLLocationDegrees)
        
        
        let region = MKCoordinateRegionMakeWithDistance(coord, 500, 500)
        mapView.setRegion(region, animated: true)
        
        let addedAnnotation :MKPointAnnotation = MKPointAnnotation.init()
        mapView.addAnnotation(addedAnnotation)
        addedAnnotation.coordinate = coord
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MapView Delegates
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: "myPin")
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
        }
        pin?.annotation=annotation
        return pin
        
    }
    

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        let vc = segue.destination as! AddDetailsViewController
        vc.studentData = studentData
     }
 
    
}
