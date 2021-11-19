import Foundation
import CoreLocation

class LocationService {
    static let shared = LocationService()
    
    private init() {}
    
    func getCoordinate(place: String, completion: @escaping (Result<CLLocationCoordinate2D, LocationError>) -> Void) {
        CLGeocoder().geocodeAddressString(place) { placemarks, error in
            if let error = error as? CLError {
                switch error.code {
                case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
                    completion(.failure(.placeNotFound(place)))
                    
                case .network:
                    completion(.failure(.networkFailure))
                    
                default:
                    completion(.failure(.other(error)))
                }
                return
            }
            
            guard let coordinate = placemarks?.first?.location?.coordinate else {
                completion(.failure(.placeNotFound(place)))
                return
            }
            
            completion(.success(coordinate))
        }
    }
    
    func getAddress(location: CLLocation, completion: @escaping (Result<String, LocationError>) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error as? CLError {
                completion(.failure(.other(error)))
                return
            }
            
            let name = placemarks?.first?.name ?? ""
            let city = placemarks?.first?.locality ?? ""
            let state = placemarks?.first?.administrativeArea ?? ""
            
            completion(.success("\(name), \(city), \(state)"))
        }
    }
}
