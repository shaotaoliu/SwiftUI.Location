import Foundation
import CoreLocation

struct IdentifiablePlace: Identifiable {
    let id = UUID()
    let location: CLLocationCoordinate2D
}

