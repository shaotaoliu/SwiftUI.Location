import MapKit
import CoreLocation

class PlaceListViewModel: ViewModel {
    @Published var places: [Place] = []
    @Published var showAddSheet = false
    @Published var searchText = ""
    
    static let shared = PlaceListViewModel()
    
    override private init() {
        super.init()
        places = fetchFromUserDefaults()
    }
    
    var searchedPlaces: [Place] {
        if searchText.isEmpty {
            return places
                .sorted { $0.name < $1.name }
        }
        
        return places
            .filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            .sorted { $0.name < $1.name }
    }
    
    func add(name: String, completion: @escaping (Bool) -> Void) {
        if name.isEmpty {
            self.error = .nameIsEmpty
            completion(false)
            return
        }
        
        if places.contains(where: { $0.name == name }) {
            self.error = .nameAlreadyExists(name)
            completion(false)
            return
        }
        
        LocationService.shared.getCoordinate(place: name) { result in
            switch result {
            case .success(let coordinate):
                self.places.append(Place(name: name, coordinate: coordinate))
                self.saveToUserDefaults()
                completion(true)
                
            case .failure(let error):
                self.error = error
                completion(false)
            }
        }
    }
    
    func remove(ids: [UUID]) {
        places.removeAll(where: { ids.contains($0.id)} )
        saveToUserDefaults()
    }
    
    private func saveToUserDefaults() {
        let data = try! JSONEncoder().encode(places)
        UserDefaults.standard.set(data, forKey: "LocationApp.places")
    }
    
    private func fetchFromUserDefaults() -> [Place] {
        if let data = UserDefaults.standard.data(forKey: "LocationApp.places") {
            return try! JSONDecoder().decode([Place].self, from: data)
        }
        return []
    }
}
