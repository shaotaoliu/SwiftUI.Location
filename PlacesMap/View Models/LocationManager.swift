import CoreLocation
import MapKit

class LocationManager: ViewModel {
    @Published var place = Place.default
    @Published var needPermission = false
    @Published var locationServiceEnabled = false
    
    static let shared = LocationManager()
    
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
    
    override private init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func requestAuthorization() {
        if locationManager.authorizationStatus == .authorizedWhenInUse ||
            locationManager.authorizationStatus == .authorizedAlways {
            locationServiceEnabled = true
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // Requests the one-time delivery of the user's current location
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    // Starts the generation of updates that report the user's current location
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
}
