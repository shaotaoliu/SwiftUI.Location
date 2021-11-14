import Foundation
import CoreLocation
import MapKit

class MyLocationManager: ViewModel, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion()
    @Published var address: String = ""
    
    var denied: Bool {
        return errorMessage == Constants.Denied
    }
    
    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        // The minimum distance (in meters) the device must move horizontally before an update event is generated
        manager.distanceFilter = kCLDistanceFilterNone
        
        // The accuracy of the location data that your app wants to receive
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Pause location updates when the location data is unlikeyly to change to improve battery life
        manager.pausesLocationUpdatesAutomatically = true
        
        // The location manager is being used dspecifically during vehicular navigation
        manager.activityType = .automotiveNavigation
        
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
            errorMessage = Constants.Denied
            
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
        if let error = error as? CLError, error.code == .denied {
            manager.stopUpdatingLocation()
            errorMessage = Constants.Denied
            return
        }
        
        errorMessage = error.localizedDescription
    }
    
    // Called when a new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // The most recent location update is at the end of the array.
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
