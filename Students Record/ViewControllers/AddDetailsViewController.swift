//
//  AddDetailsViewController.swift
//  Students Record
//
//  Created by Bindu on 25/04/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit
import CoreLocation

class AddDetailsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet var markLabel: UITextField!
    @IBOutlet var ageLabel: UITextField!
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var rollnumLabel: UITextField!
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var scrlContainer: UIScrollView!
    let ref = FIRDatabase.database().reference(withPath:"StudentList")
    var studentData : FIRDataSnapshot = FIRDataSnapshot()
    let addedAnnotation :MKPointAnnotation = MKPointAnnotation.init()
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupKeyboard()
        mapView.layer.cornerRadius = 3
        mapView.layer.borderColor = UIColor.black.cgColor
        mapView.layer.borderWidth = 1
        
        
        locationManager = CLLocationManager ()
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        
        if (!studentData.key.isEmpty) {
            
            rollnumLabel.isUserInteractionEnabled = false
            rollnumLabel.text = studentData.key
            let data : [String:String] = studentData.value as! [String : String];
            nameLabel.text = data["name"]
            ageLabel.text = data["age"]
            markLabel.text = data["mark"]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    func setMapView(coord:CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegionMakeWithDistance(coord, 500, 500)
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotation(addedAnnotation)
        addedAnnotation.coordinate = coord
    }
    
    func setupKeyboard() {
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action:#selector(keyboardDoneClicked(_:)) )
        keyboardToolbar.items = [flexBarButton,doneBarButton]
        
        rollnumLabel.inputAccessoryView = keyboardToolbar
        ageLabel.inputAccessoryView = keyboardToolbar
        markLabel.inputAccessoryView = keyboardToolbar
        
    }
    
    // MARK: - IBActions
    
    @IBAction func keyboardDoneClicked (_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
        
        let location = "\(mapView.centerCoordinate.latitude),\(mapView.centerCoordinate.longitude)"
        print(location)
        
        if studentData.key.isEmpty {
            let studentRef = ref.child(rollnumLabel.text!)
            studentRef.setValue([
                "name":nameLabel.text!,
                "age":ageLabel.text!,
                "mark":markLabel.text!,
                "lat":mapView.centerCoordinate.latitude,
                "lng":mapView.centerCoordinate.longitude
                ])
        } else {
            
            let studentRef = ref.child(studentData.key)
            studentRef.updateChildValues([
                "name":nameLabel.text!,
                "age":ageLabel.text!,
                "mark":markLabel.text!,
                "lat":mapView.centerCoordinate.latitude,
                "lng":mapView.centerCoordinate.longitude
                ])
            
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - MapView Delegates
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: "myPin")
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
        }
        pin?.annotation=annotation
        pin?.isDraggable = true
        return pin
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        if newState == MKAnnotationViewDragState.starting {
            print((view.annotation?.coordinate.latitude)!)
            print((view.annotation?.coordinate.longitude)!)
        } else if newState == MKAnnotationViewDragState.ending {
            
            let droppedAt :CLLocationCoordinate2D = (view.annotation?.coordinate)!
            setMapView(coord: droppedAt)
            
        }
    }
    
    // MARK: - CLLocationManager Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations.last!
        
        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        setMapView(coord: center)
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - UITextField Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrlContainer.setContentOffset(CGPoint(x:0,y:textField.frame.origin.y+10), animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.isEqual(rollnumLabel) {
            nameLabel.becomeFirstResponder()
        } else if textField.isEqual(nameLabel) {
            ageLabel.becomeFirstResponder()
        } else if textField.isEqual(ageLabel) {
            markLabel.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        scrlContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
