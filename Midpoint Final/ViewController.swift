//
//  ViewController.swift
//  Midpoint Final
//
//  Created by Kyle Thornton on 5/15/16.
//  Copyright © 2016 Thorn129. All rights reserved.
//
// http://www.innofied.com/implement-location-tracking-using-mapkit-in-swift/
//


import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var previousLocation : CLLocation!
    var friendZip : String!
    
    //let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    //let apikey = "AIzaSyBWUt3mskqT-zi4wxZfZzrG_R0bf8fFvjE"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.delegate = self;
        

        
        
        
        // user activated automatic authorization info modes
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        //mapview setup to show user location
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
    
        
        
        /*
        var uilgr = UILongPressGestureRecognizer(target: mapView, action: "addAnnotation")
        
        mapView.addGestureRecognizer(uilgr)
        
        func addAnnotation(gestureRecognizer:UIGestureRecognizer){
            if gestureRecognizer.state == UIGestureRecognizerState.Began {
                var touchPoint = gestureRecognizer.locationInView(mapView)
                var newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinates
                
                CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
                    if error != nil {
                        print("Reverse geocoder failed with error" + error!.localizedDescription)
                        return
                    }
                    
                    if placemarks!.count > 0 {
                        let pm = placemarks![0] as! CLPlacemark
                        
                        // not all places have thoroughfare & subThoroughfare so validate those values
                        annotation.title = pm.thoroughfare! + ", " + pm.subThoroughfare!
                        annotation.subtitle = pm.subLocality
                        self.mapView.addAnnotation(annotation)
                        print(pm)
                    }
                    else {
                        annotation.title = "Unknown Place"
                        self.mapView.addAnnotation(annotation)
                        print("Problem with the data received from geocoder")
                    }
                })
            }
        }
        
        */

    }
    
    
    
    //@IBAction func enterButton(sender: AnyObject) {
        //friendZip = textField.text
        //getLatLngForZip(friendZip)
        //print(friendLon)
    //}
    
    
    /*
    var friendLat : CLLocationDegrees!
    var friendLon : CLLocationDegrees!
    
    func getLatLngForZip(zipCode: String) {
        let url = NSURL(string: "\(baseUrl)address=\(zipCode)&key=\(apikey)")
        let data = NSData(contentsOfURL: url!)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        
        if let result = json["results"] as? NSArray {
            if let geometry = result[0]["geometry"] as? NSDictionary {
                if let location = geometry["location"] as? NSDictionary {
                    let latitude = location["lat"] as! CLLocationDegrees
                    let longitude = location["lng"] as! CLLocationDegrees
                    print("\n\(latitude), \(longitude)")
                    
                    friendLat = latitude
                    friendLon = longitude
                    
                }
            }
        }
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        mapView.mapType = MKMapType(rawValue: 0)!
    }
    
    
    override func viewWillAppear(animated: Bool) {
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if let oldLocationNew = oldLocation as CLLocation?{
            let oldCoordinates = oldLocationNew.coordinate
            let newCoordinates = newLocation.coordinate
            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            mapView.addOverlay(polyline)
        }

    }
    
    
    /*
    @IBAction func addFriendsLocation(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.Began { return }
      
        let touchLocation = sender.locationInView(mapView)
        let locationCoordinate = mapView.convertPoint(touchLocation, toCoordinateFromView: mapView)
        let friendLoc = MKPointAnnotation()
        friendLoc.coordinate = CLLocationCoordinate2D(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        friendLoc.title = "Friend's Location"
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(friendLoc)
    }
    */
    
    
    
    @IBAction func didLongPress(sender: UILongPressGestureRecognizer) {
        var mapCoord:CLLocationCoordinate2D!
        if sender.state == .Began{
            let gr = sender as! UILongPressGestureRecognizer
            let pressLocation = gr.locationInView(mapView)
            mapCoord = mapView.convertPoint(pressLocation, toCoordinateFromView : mapView)
            
        }
    print(mapCoord)
        
    }
    
    
    
    
    
}

    
    
    /*
    // MARK :- MKMapView delegate
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.redColor()
            pr.lineWidth = 5
            return pr
        }
        
        return nil
    }
 */




class MidpointFormula {
    
    //        /** Degrees to Radians **/
    
    class func degreeToRadian(angle:CLLocationDegrees) -> CGFloat{
        
        return (  (CGFloat(angle)) / 180.0 * CGFloat(M_PI)  )
        
    }
    
    //        /** Radians to Degrees **/
    
    class func radianToDegree(radian:CGFloat) -> CLLocationDegrees{
        
        return CLLocationDegrees(  radian * CGFloat(180.0 / M_PI)  )
        
    }
    
    class func middlePointOfListMarkers(listCoords: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D{
    
        var x = 0.0 as CGFloat
        var y = 0.0 as CGFloat
        var z = 0.0 as CGFloat
        
        
        for coordinate in listCoords{
        
            let lat:CGFloat = degreeToRadian(coordinate.latitude)
            let lon:CGFloat = degreeToRadian(coordinate.longitude)
            x = x + cos(lat) * cos(lon)
            y = y + cos(lat) * sin(lon);
            z = z + sin(lat);
            
        }
        
        x = x/CGFloat(listCoords.count)
        y = y/CGFloat(listCoords.count)
        z = z/CGFloat(listCoords.count)
        
        
        let resultLon: CGFloat = atan2(y, x)
        let resultHyp: CGFloat = sqrt(x*x+y*y)
        let resultLat:CGFloat = atan2(z, resultHyp)
        

        let newLat = radianToDegree(resultLat)
        let newLon = radianToDegree(resultLon)
        let result:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: newLat, longitude: newLon)
        
        return result
        
    }
}



