//
//  FirstViewController.swift
//  CoreLocation
//
//  Created by Maurício T Zaquia on 9/10/14.
//  Copyright (c) 2014 zaquia. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapKitViewController: UIViewController , CLLocationManagerDelegate , MKMapViewDelegate {

	
	@IBOutlet weak var mapView: MKMapView!
	var locationManager = CLLocationManager()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		mapView.delegate = self

		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()

		var point = MKPointAnnotation();
		point.coordinate = CLLocationCoordinate2DMake(37.331507, -122.033354)
		point.title = "Nice Restaurant"
		point.subtitle = "Very close to you."

		mapView.addAnnotation(point)
		mapView.showAnnotations([point], animated: false)

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == CLAuthorizationStatus.AuthorizedWhenInUse  {

			mapView.showsUserLocation = true

			if let location = locationManager.location?.coordinate {
				mapView.setCenterCoordinate(location, animated: true)
				mapView.camera.altitude = pow(2, 11)
			} else {
				locationManager.startUpdatingLocation()
			}

		}
	}

	func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {

		locationManager.stopUpdatingLocation()

		if let location = locations.last as? CLLocation {
			mapView.setCenterCoordinate(location.coordinate, animated: true)
			mapView.camera.altitude = pow(2, 11)
		}
	}

	func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {

		var identifier = "CustomAnnotation"

		if annotation.isKindOfClass(MKUserLocation) {
			return nil
		}

		if annotation.isKindOfClass(MKPointAnnotation) {
			var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)

			if pin == nil {
				pin = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
				pin.image = UIImage(named: "red_pin")
				pin.centerOffset = CGPointMake(0, -10)
				pin.canShowCallout = true


				// Callout
				var button = UIButton.buttonWithType(.DetailDisclosure) as UIButton
				pin!.leftCalloutAccessoryView = button

				var image = UIImageView(image: UIImage(named: "item_check"))
				pin!.rightCalloutAccessoryView = image


			} else {
				pin!.annotation = annotation
			}

			return pin
		}
		
		return nil
		
	}

	func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {

		if control is UIButton {
			var alert = UIAlertController(title: "Nice Restaurant", message: "Welcome!", preferredStyle: UIAlertControllerStyle.Alert)
			var action = UIAlertAction(title: "Thanks", style: UIAlertActionStyle.Cancel, handler: nil)

			alert.addAction(action)
			self.presentViewController(alert, animated: true, completion: nil)
		}
		
	}


}

