import SwiftUI
import MapKit
import CoreLocation

struct PlaceMapView: View {
    var place: Place
    @State var region = MKCoordinateRegion()
    
    var body: some View {
        let places = [
            IdentifiablePlace(location: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
        ]
        
        Map(coordinateRegion: $region, annotationItems: places) { place in
            MapPin(coordinate: place.location, tint: Color.purple)
        }
        .onAppear {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: place.latitude,
                                               longitude: place.longitude),
                span: Constants.CoordinateSpan)
        }
        .navigationTitle(place.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlaceMapView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceMapView(place: Place(name: "Apple city", coordinate: CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020)))
    }
}
