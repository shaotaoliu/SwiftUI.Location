import SwiftUI

struct AddPlaceView: View {
    @StateObject var vm = PlaceListViewModel.shared
    @State var name: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter Place Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.words)
                
                Button(action: {
                    name = ""
                }, label: {
                    Image(systemName: "xmark.circle")
                        .font(.title3)
                })
            }
            .padding()
            .padding(.top, 50)
            
            HStack(spacing: 50) {
                Button("Cancel") {
                    vm.showAddSheet = false
                }
                .foregroundColor(.white)
                .frame(width: 90, height: 36)
                .background(.blue)
                .cornerRadius(10)
                
                Button("Add") {
                    vm.add(name: name) { success in
                        if success {
                            vm.showAddSheet = false
                        }
                    }
                }
                .foregroundColor(.white)
                .frame(width: 90, height: 36)
                .background(.blue)
                .cornerRadius(10)
                .alert("Error", isPresented: $vm.hasError, presenting: vm.error, actions: { error in
                }, message: { error in
                    Text(error.localizedDescription)
                })
            }
            
            Spacer()
        }
    }
}

struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceView()
    }
}
