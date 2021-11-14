import SwiftUI
import MapKit
import CoreLocation

struct MyLocationView: View {
    @StateObject var manager = MyLocationManager()
    
    var body: some View {
        Map(coordinateRegion: $manager.region, showsUserLocation: true)
            .navigationTitle(manager.address)
            .navigationBarTitleDisplayMode(.inline)
            .alert("", isPresented: $manager.hasError, presenting: manager.errorMessage, actions: { errorMessage in
            }, message: { errorMessage in
                Text(errorMessage)
            })
    }
}

struct MyLocationView_Previews: PreviewProvider {
    static var previews: some View {
        MyLocationView()
    }
}
