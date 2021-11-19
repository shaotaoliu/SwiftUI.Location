import Foundation
import CoreLocation

struct Place: Codable {
    let id: UUID
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.id = UUID()
        self.name = name
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    static let `default` = Place(
        name: "Apple city",
        coordinate: CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020)
    )
}
