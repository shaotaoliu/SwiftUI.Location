import MapKit
import CoreLocation

class PlaceMapViewModel: ViewModel {
    @Published var searchText = ""
    @Published var places: [Place] = []
    @Published var region: MKCoordinateRegion!
    @Published var placeAnnotations = [IdentifiablePlace]()
    
    var place: Place
    
    init(place: Place) {
        self.place = place
        super.init()
        
        selectPlace(place: place)
    }
    
    func searchQuery() {
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        
        MKLocalSearch(request: request).start { (response, _) in
            guard let result = response else {
                return
            }
            
            self.places = result.mapItems.compactMap {
                Place(name: $0.placemark.name ?? "",
                      coordinate: CLLocationCoordinate2D(latitude: $0.placemark.coordinate.latitude,
                                                         longitude: $0.placemark.coordinate.longitude))
            }
        }
    }
    
    func selectPlace(place: Place) {
        searchText = ""
        placeAnnotations.removeAll()
        
        let coordinate = CLLocationCoordinate2D(latitude: place.latitude,
                                                longitude: place.longitude)
        
        region = MKCoordinateRegion(center: coordinate, span: Constants.CoordinateSpan)
        placeAnnotations.append(IdentifiablePlace(location: coordinate))
    }
}
