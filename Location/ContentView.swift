import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var vm = PlaceListViewModel()
    
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
                    AddPlaceView(vm: vm)
                }
                
                if CLLocationManager.locationServicesEnabled() {
                    NavigationLink(destination: MyLocationView()) {
                        HStack {
                            Text("Show My Location")
                            Image(systemName: "chevron.forward")
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
