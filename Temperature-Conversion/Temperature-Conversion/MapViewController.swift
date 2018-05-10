//
//  MapViewController.swift
//  Temperature-Conversion
//
//  Created by Vo Huy on 5/9/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties
    var mapView: MKMapView!
    var userLocationBtn: UIButton!
    var locationManager: CLLocationManager?
    let vinhAnnotation = Artwork(title: "My hometown", locationName: "Vinh city", discipline: "City", coordinate: CLLocationCoordinate2D(latitude: 18.6796, longitude: 105.6813))
    let phuketAnnotation = Artwork(title: "A place I visitted", locationName: "Phuket Island", discipline: "Island", coordinate: CLLocationCoordinate2D(latitude: 7.9519, longitude: 98.3381))
    let sauAnnotation = Artwork(title: "My workplace", locationName: "Collegedale city", discipline: "Work", coordinate: CLLocationCoordinate2D(latitude: 35.0531, longitude: -85.0502))
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        mapView.delegate = self
        mapView.addAnnotation(vinhAnnotation)
        mapView.addAnnotation(phuketAnnotation)
        mapView.addAnnotation(sauAnnotation)
        locationManager = CLLocationManager()
        
        // Set it as the view of this view controller
        view = mapView
        
        // All tab titles
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        // add a segmented control
        let segmentedControl = UISegmentedControl(items: [standardString,hybridString, satelliteString])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        // the map view's constraints
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        // add margins
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        // setting up the user location button
        addUserLocationBtn()
    }
    
    override func viewDidLoad() {
        print("running map")
    }
    
    // MARK: Private methods
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func addUserLocationBtn() {
//        userLocationBtn = UIButton(frame: CGRect(x: 24, y: 120, width: 120, height: 48))
        userLocationBtn = UIButton.init(type: .system)
        userLocationBtn.setTitle("Your location", for: .normal)
        userLocationBtn.translatesAutoresizingMaskIntoConstraints = false
        userLocationBtn.addTarget(self, action: #selector(MapViewController.toUserLocation(sender:)), for: .touchUpInside)
        self.view.addSubview(userLocationBtn)
        
        // the button's constraints
        let topBtnConstraint = userLocationBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let leadingBtnConstraint = userLocationBtn.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let trailingBtnConstraint = userLocationBtn.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        
        topBtnConstraint.isActive = true
        leadingBtnConstraint.isActive = true
        trailingBtnConstraint.isActive = true
    }
    
    // a handler for user location button => go to the user's location
    @objc func toUserLocation(sender: UIButton!) {
        locationManager?.requestWhenInUseAuthorization()
        //fire up the method mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
        mapView.showsUserLocation = true 
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        mapView.setRegion(zoomedInCurrentLocation, animated: true)
    }
}

extension MapViewController {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Artwork else { return nil }
        // when we dequeue a reusable annotation, give it an identifier
        // if we have multiple styles of annotations, we should have a unique identifer for each one
        // this prevents unexpected behavior if we mistakenly dequeue an identifer of a deifferent type. SAME IDEA for tableView
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // a map view reuses annotation views that are no longer visible. SAME for tableView
        // check to see if a reusable annotation view is available
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // no reusable annotaion is avaiable, creating a new one
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            // the view is able to display extra information
            view.canShowCallout = true
            // the offset at which to call out the bubble
            view.calloutOffset = CGPoint(x: 0, y: 20)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
