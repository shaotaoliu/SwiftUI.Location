import SwiftUI
import MapKit
import CoreLocation

struct MyLocationView: View {
    @StateObject var manager = MyLocationManager()
    
    var body: some View {
        Map(coordinateRegion: $manager.region, showsUserLocation: true)
            .navigationTitle(manager.address)
            .navigationBarTitleDisplayMode(.inline)
            .alert(manager.denied ? "Permission Denied" : "Error" , isPresented: $manager.hasError, presenting: manager.errorMessage, actions: { errorMessage in
                if manager.denied {
                    Button(action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }, label: {
                        Text("Turn on in Settings")
                    })
                }
                
                Button("Keep Location Services Off") {}
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
