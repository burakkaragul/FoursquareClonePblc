//
//  MapVC.swift
//  FoursquareCloneParse
//
//  Created by Burak Karagül on 13.03.2022.
//

import UIKit
import MapKit
import Parse



class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    @IBOutlet weak var mapView: MKMapView!
    

    
    var locationManager = CLLocationManager()
    

    var chosenLatitude = ""
    var chosenLongitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.done, target: self, action: #selector(saveButtonClicked))
        
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        
        
        mapView.delegate = self
        locationManager.delegate = self
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        locationManager.requestWhenInUseAuthorization()
        

        
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation))

        
        recognizer.minimumPressDuration = 2
        
        
        mapView.addGestureRecognizer(recognizer)
        
    }
    
    
    @objc func chooseLocation(gestureRecognizer : UIGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            
    
            
            let touches = gestureRecognizer.location(in: self.mapView)
            
            
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            
            
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            
            self.mapView.addAnnotation(annotation)
            
            
            PlaceModel.sharedInstance.placeLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(coordinates.longitude)
            
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        locationManager.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        
        let span = MKCoordinateSpan(latitudeDelta: 0.35, longitudeDelta: 0.35)
        
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        
        mapView.setRegion(region, animated: true)
        
    }
                                       

    
    @objc func backButtonClicked(){
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @objc func saveButtonClicked(){
        
        
        
        let placemodel = PlaceModel.sharedInstance
        
        
        let object = PFObject(className: "Places")
        
        
        object["name"] = placemodel.placeName
        object["type"] = placemodel.placeType
        object["atmosphere"] = placemodel.placeAtmosphere
        object["latitude"] = placemodel.placeLatitude
        object["longitude"] = placemodel.placeLongitude
        

        
        if let imageData = placemodel.placeImage.jpegData(compressionQuality: 0.5){
            
            
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
            
        }
        
        
        object.saveInBackground { success, error in
            if error != nil{
                
                
                self.makeAlert(title: "Error", message: error!.localizedDescription)
                
            }else{
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
        
        
        
        
        
    }
   
    func makeAlert(title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                      
                      
                      let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                      alert.addAction(okButton)
                      self.present(alert, animated: true, completion: nil)
    }

}
