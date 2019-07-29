//
//  ViewController.swift
//  MapUtilityTest
//
//  Created by Apple on 02/05/19.
//  Copyright © 2019 FlairIt. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
//import GoogleMaps

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var cordinates = [(String, Double, Double)]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        if let path = Bundle.main.path(forResource: "latLongFile", ofType: "txt"){
            do {
                let text = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                let lines:[String] = text.components(separatedBy: "\n")
                for cordinate in lines {
                    let newCordinate = cordinate.trim()
                    let arr = newCordinate.components(separatedBy: " ")
                    if arr.count == 3 {
                        cordinates.append((arr[0],arr[1].toDouble, arr[2].toDouble))
                    }
                }
                
            } catch let _ as NSError  {
                
            }
            
        }
        
        openMapForPlace(lat:Double(cordinates[0].1) , lon: Double(cordinates[0].2))
        
        for index in 0 ..< cordinates.count {
            let lat = cordinates[index].1
            let long = cordinates[index].2
            let coordinate = CLLocationCoordinate2D(latitude: lat , longitude: long )
            let annotations = MKPointAnnotation()
            annotations.coordinate = coordinate
            annotations.title = "l-\(index)  \(cordinates[index].0)"
            mapView.addAnnotation(annotations)
        }
    }
    func openMapForPlace(lat:Double, lon: Double) {
        
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = lon
        
        let regionDistance:CLLocationDistance = 200
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setCenter(coordinates, animated: true)
        mapView.setRegion(regionSpan, animated: true)
    }
    
}
extension ViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
}
extension String {
    var toDouble: Double {
        return Double(self) != nil ? Double(self)! : 0.0
    }
    func trim() -> String
    {
        return self.replacingOccurrences(of: ",", with: "")
    }
}

