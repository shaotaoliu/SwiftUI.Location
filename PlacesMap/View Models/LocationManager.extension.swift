import CoreLocation
import MapKit

extension LocationManager: CLLocationManagerDelegate {

    // Called when the app creates the location manager and when the authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .restricted:
            self.error = .locationServiceRestricted
            
        case .denied:
            self.needPermission = true
            self.error = .locationPermissionDenied
            
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationServiceEnabled = true
            
        @unknown default:
            self.error = .unknownAuthorizationStatus(manager.authorizationStatus)
        }
    }
    
    // Called when the location manager was unable to retrieve a location value
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            manager.stopUpdatingLocation()
            self.error = .locationPermissionDenied
            return
        }
        
        self.error = .other(error)
    }
    
    // Called when a new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // The most recent location update is at the end of the array.
        if let location = locations.last {
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                    longitude: location.coordinate.longitude)
            
            LocationService.shared.getAddress(location: location) { result in
                switch result {
                case .success(let address):
                    self.place = Place(name: address, coordinate: coordinate)
                    
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }
}
