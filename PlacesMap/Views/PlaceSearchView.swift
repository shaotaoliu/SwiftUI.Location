import SwiftUI

struct PlaceSearchView: View {
    @ObservedObject var vm: PlaceMapViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search", text: $vm.searchText)
                    .colorScheme(.light)
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.white)
            
            if !vm.places.isEmpty && vm.searchText != "" {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(vm.places, id: \.id) { place in
                            Text(place.name)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .onTapGesture(perform: {
                                    vm.selectPlace(place: place)
                                })
                            
                            Divider()
                        }
                    }
                    .padding(.top)
                }
                .background(Color.white)
            }
        }
        .padding()
        .onChange(of: vm.searchText, perform: { value in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                if value == vm.searchText {
                    self.vm.searchQuery()
                }
            })
        })
    }
}
struct PlaceSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue
            VStack {
                PlaceSearchView(vm: PlaceMapViewModel(place: Place.default))
                Spacer()
            }
        }
    }
}
