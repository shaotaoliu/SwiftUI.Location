import Foundation
import CoreLocation

enum LocationError: Error, LocalizedError {
    
    case locationPermissionDenied
    case locationServiceRestricted
    case unknownAuthorizationStatus(CLAuthorizationStatus)
    case placeNotFound(String)
    case networkFailure
    case nameIsEmpty
    case nameAlreadyExists(String)
    case other(Error)
    
    var errorDescription: String? {
        switch self {
        case .locationPermissionDenied:
            return NSLocalizedString("Location services are denied. You can turn on services in Settings.", comment: "")
            
        case .locationServiceRestricted:
            return NSLocalizedString("Location services are disabled", comment: "")
            
        case .unknownAuthorizationStatus(let authorizationStatus):
            return NSLocalizedString("Unknown authorization status: \(authorizationStatus)", comment: "")
            
        case .placeNotFound(let place):
            return NSLocalizedString("Unable to find the place: \(place)", comment: "")
            
        case .networkFailure:
            return NSLocalizedString("Network is unavailable", comment: "")
            
        case .nameIsEmpty:
            return NSLocalizedString("Network is unavailable", comment: "")
            
        case .nameAlreadyExists(let name):
            return NSLocalizedString("\(name) already exists", comment: "")
            
        case .other(let error):
            return error.localizedDescription
        }
    }
}
