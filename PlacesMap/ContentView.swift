import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var vm = PlaceListViewModel.shared
    @StateObject var manager = LocationManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(vm.searchedPlaces, id: \.id) { place in
                        NavigationLink(destination: PlaceMapView(place: place), label: {
                            Text(place.name)
                        })
                    }
                    .onDelete { indexSet in
                        vm.remove(ids: indexSet.map { vm.searchedPlaces[$0].id })
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Places")
                .navigationBarItems(trailing: Button(action: {
                    vm.showAddSheet = true
                }, label: {
                    Image(systemName: "plus")
                }))
                .searchable(text: $vm.searchText)
                .sheet(isPresented: $vm.showAddSheet) {
                    PlaceAddView(vm: vm)
                }
                
                if CLLocationManager.locationServicesEnabled() && manager.locationServiceEnabled {
                    NavigationLink(destination: PlaceMapView(place: manager.place)) {
                        HStack {
                            Text("Show My Location")
                            Image(systemName: "chevron.forward")
                        }
                    }
                }
            }
            .onAppear(perform: {
                manager.requestAuthorization()
            })
            .alert("Permission Denied", isPresented: $manager.hasError, presenting: manager.error, actions: { error in
                if manager.needPermission {
                    Button(action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }, label: {
                        Text("Turn on in Settings")
                    })
                    
                    Button("Keep Location Services Off") {
                        
                    }
                }
            }, message: { error in
                Text(error.localizedDescription)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
