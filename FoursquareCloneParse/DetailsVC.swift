//
//  DetailsVC.swift
//  FoursquareCloneParse
//
//  Created by Burak Karagül on 14.03.2022.
//

import UIKit
import MapKit
import Parse



class DetailsVC: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var detailsNameLbl: UILabel!
    @IBOutlet weak var detailsImageView: UIImageView!
    
    @IBOutlet weak var detailsTypeLbl: UILabel!
    @IBOutlet weak var detailsAtmosphereLbl: UILabel!
    
    @IBOutlet weak var detailsMapView: MKMapView!
    
    
    var chosenPlaceId=""
    var chosenPlaceLatitude = Double()
    var chosenPlaceLongitude = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        getDataFromParse()
        detailsMapView.delegate = self

    }
    
    func makeAlert(title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                      
                      
                      let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                      alert.addAction(okButton)
                      self.present(alert, animated: true, completion: nil)

    
    }
    
    func getDataFromParse(){
        
                
                let query = PFQuery(className: "Places")
                query.whereKey("objectId", equalTo: chosenPlaceId)
                query.findObjectsInBackground { objects, error in
                    if error != nil {
                        self.makeAlert(title: "Error", message: error!.localizedDescription)
                    }else{
                        
                        
                        if objects != nil{
                            if objects!.count > 0 {
                             
                                                    
                                let chosenPlaceObject = objects![0]
                                if let placeName = chosenPlaceObject.object(forKey: "name") as? String{
                                    self.detailsNameLbl.text = placeName
                                }
                                
                                if let placeType = chosenPlaceObject.object(forKey: "type") as? String{
                                    self.detailsTypeLbl.text = placeType
                                }
                                
                                if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String{
                                    self.detailsAtmosphereLbl.text = placeAtmosphere
                                }
                                    
                                if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String{
                                    if let placeLatitudeDouble = Double(placeLatitude){
                                        self.chosenPlaceLatitude = placeLatitudeDouble
                                    }
                                }
                                
                                if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String{
                                    if let placeLongitudeDouble = Double(placeLongitude){
                                        self.chosenPlaceLongitude = placeLongitudeDouble
                                    }
                                }
                                
                                
                                if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject{
                                    imageData.getDataInBackground { data, error in
                                        if error == nil{
                                            if data != nil{
                                            self.detailsImageView.image = UIImage(data: data!)
                                            }
                                        }
                                    }
                                }
                                
                                
                                let location = CLLocationCoordinate2D(latitude: self.chosenPlaceLatitude, longitude: self.chosenPlaceLongitude)
                                
                                
                                let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                                
                                
                                let region = MKCoordinateRegion(center: location, span: span)
                                
                                self.detailsMapView.setRegion(region, animated: true)
                                
                                
                                let annotation = MKPointAnnotation()
                                annotation.coordinate = location
                                annotation.title = self.detailsNameLbl.text
                                annotation.subtitle = self.detailsTypeLbl.text
                                self.detailsMapView.addAnnotation(annotation)
                                
                                
                            }
                            
                        }
                        
                    }
                }
                
                
    }
    
    
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        
        
        let reuseId = "pin"
        
        var pinview = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinview == nil{
            pinview = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
           
            
            pinview?.canShowCallout = true
            
            
            let button = UIButton(type: .detailDisclosure)
            
            
            pinview?.rightCalloutAccessoryView = button

        }else{
            
            
            pinview?.annotation = annotation
        }
        
        return pinview
        
    }
    
    
    
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        if self.chosenPlaceLatitude != 0.0 && self.chosenPlaceLongitude != 0.0{
            
            let requestLocation = CLLocation(latitude: chosenPlaceLatitude, longitude: chosenPlaceLongitude)
            

            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                
                if let placemark = placemarks{
                    if placemark.count > 0{
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsNameLbl.text
                        
//                        Hangi şekilde yol tarifi verilsin (Araba, yürüyerek)
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
                
            }
            
        }
        
    }
    
}
