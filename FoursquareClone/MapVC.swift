//
//  MapVC.swift
//  FoursquareClone
//
//  Created by MacxbookPro on 11.12.2019.
//  Copyright © 2019 MacxbookPro. All rights reserved.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController ,MKMapViewDelegate ,CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    //var chosenLatitude = ""
    //var chosenLongitude = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(saveLocation))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(backPlacesVC))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest//1 km hatali gosterir
        locationManager.requestWhenInUseAuthorization()//kullanici kullanirken konumu alir
        locationManager.startUpdatingLocation()//guncellemeye basla

        // Do any additional setup after loading the view.
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(pinLocations(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)//ne kadar kucuk o kadar zoom
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    @objc func pinLocations(gestureRecognizer : UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began{
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            let placeModel = PlaceModel.sharedInstance
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = placeModel.placeName
            annotation.subtitle = placeModel.placeType
            
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.placeLatitude = String(touchedCoordinates.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(touchedCoordinates.longitude)
            //self.chosenLongitude = String(touchedCoordinates.longitude)
        }
    }
    
    @objc func saveLocation(){
        //parse
        //burada kendimiz olusturuyoruz veri tabanimizi
        let placeModel = PlaceModel.sharedInstance
        
        let object = PFObject(className: "Places")//konumlar dersen baska bi tane olusturur oraya kaydeder
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        //bunlari sonradan ekledik kafan karismasin ama mantik hep ayni
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        object.saveInBackground { (success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Hata", message: error?.localizedDescription ?? "Kaydedilemedi", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert,animated: true,completion: nil)
                
            }else{
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
        
        
    }
    @objc func backPlacesVC(){
        self.dismiss(animated: true, completion: nil)
        
    }


}
