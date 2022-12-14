//
//  LocationHelper.swift
//  Infrastruct
//
//  This class serves as the enviormentObject for our MapView, it is how our mapView obtains geodata and how the map interacts with the rest of our application.
//  Created by devadmin on 10/4/22.
//

import CoreLocation

class LocationHelper: NSObject, ObservableObject {

    static let shared = LocationHelper()
    //2D coordinate variable to hold our coordinates
    static let DefaultLocation = CLLocationCoordinate2D(latitude: 45.8827419, longitude: -1.1932383)

    //CLLocationCoordinate2D Object
    static var currentLocation: CLLocationCoordinate2D {
        guard let location = shared.locationManager.location else {
            return DefaultLocation
        }
        return location.coordinate
    }

    private let locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil

    //Function that is called to initilize the values.
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location manager changed the status: \(status)")
    }
    
    public func locationHelper(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.location = location
    }
}

