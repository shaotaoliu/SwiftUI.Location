import SwiftUI
import MapKit
import CoreLocation

struct PlaceMapView: View {
    @StateObject var vm: PlaceMapViewModel
    
    init(place: Place) {
        self._vm = StateObject(wrappedValue: PlaceMapViewModel(place: place))
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $vm.region, annotationItems: vm.placeAnnotations) { place in
                MapPin(coordinate: place.location, tint: Color.purple)
            }
            
            VStack {
                PlaceSearchView(vm: vm)
                Spacer()
            }
        }
        .navigationTitle(vm.place.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            MKMapItem(placemark: MKPlacemark(coordinate: vm.region.center)).openInMaps()
        }, label: {
            Image(systemName: "applelogo")
                .font(.title3)
        }))
    }
}

struct PlaceMapView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceMapView(place: Place.default)
    }
}
