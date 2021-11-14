import Foundation
import CoreLocation

class LocationService {
    static let shared = LocationService()
    
    private init() {}
    
    func getCoordinate(place: String, completion: @escaping (Result<CLLocationCoordinate2D, AppError>) -> Void) {
        CLGeocoder().geocodeAddressString(place) { placemarks, error in
            if let error = error as? CLError {
                switch error.code {
                case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
                    completion(.failure(AppError(errorMessage: "Unable to find the place: \(place)")))
                    
                case .network:
                    completion(.failure(AppError(errorMessage: "Network is unavailable")))
                    
                default:
                    completion(.failure(AppError(errorMessage: error.localizedDescription)))
                }
                return
            }
            
            guard let coordinate = placemarks?.first?.location?.coordinate else {
                completion(.failure(AppError(errorMessage: "Unable to find the place: \(place)")))
                return
            }
            
            completion(.success(coordinate))
        }
    }
    
    func getAddress(location: CLLocation, completion: @escaping (Result<String, AppError>) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error as? CLError {
                completion(.failure(AppError(errorMessage: error.localizedDescription)))
                return
            }
            
            let name = placemarks?.first?.name ?? ""
            let city = placemarks?.first?.locality ?? ""
            let state = placemarks?.first?.administrativeArea ?? ""
            
            completion(.success("\(name), \(city), \(state)"))
        }
    }
}
