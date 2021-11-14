import Foundation
import CoreLocation
import MapKit

class MyLocationManager: ViewModel, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion()
    @Published var address: String = ""
    
    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        // The minimum distance (in meters) the device must move horizontally before an update event is generated
        manager.distanceFilter = 5.0
        
        // The accuracy of the location data that your app wants to receive
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Whether the app should receive location updates when suspended (The default is false)
        manager.allowsBackgroundLocationUpdates = false
        
        // Whether the status bar changes its appearance when the app uses location services in the background (The default is false)
        manager.showsBackgroundLocationIndicator = false
        
        return manager
    }()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    // Called when the app creates the location manager and when the authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .restricted:
            errorMessage = "The app is not authorized to use location services."
            
        case .denied:
            errorMessage = "The app is denied to use location services."
            
        case .authorizedAlways, .authorizedWhenInUse:
            // Starts the generation of updates that report the user's current location
            //locationManager.startUpdatingLocation()
            
            // Requests the one-time delivery of the user's current location
            locationManager.requestLocation()
            
        @unknown default:
            errorMessage = "Unknown error"
        }
    }
    
    // Called when the location manager was unable to retrieve a location value
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError {
            if error.code == .denied {
                manager.stopUpdatingLocation()
            }
        }
    }
    
    // Called when a new location data is available
    // The most recent location update is at the end of the array.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                               longitude: location.coordinate.longitude),
                span: Constants.CoordinateSpan)
            
            LocationService.shared.getAddress(location: location) { result in
                switch result {
                case .success(let address):
                    self.address = address
                    
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                }
            }
        }
    }
}
