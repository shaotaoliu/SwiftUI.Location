import MapKit
import CoreLocation

class PlaceListViewModel: ViewModel {
    @Published var places: [Place] = []
    @Published var showAddSheet = false
    @Published var searchText = ""
    
    override init() {
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
    
    func validate(name: String, completion: @escaping (CLLocationCoordinate2D?, Bool) -> Void) {
        if name.isEmpty {
            errorMessage = "Name cannot be empty"
            completion(nil, false)
            return
        }
        
        if places.contains(where: { $0.name == name }) {
            errorMessage = "\(name) already exists"
            completion(nil, false)
            return
        }
        
        LocationService.shared.getCoordinate(place: name) { result in
            switch result {
            case .success(let coordinate):
                completion(coordinate, true)
                
            case .failure(let error):
                self.errorMessage = error.errorMessage
                completion(nil, false)
            }
        }
    }
    
    func add(name: String, coordinate: CLLocationCoordinate2D) {
        places.append(Place(name: name, coordinate: coordinate))
        saveToUserDefaults()
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

struct Place: Codable {
    let id: UUID
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.id = UUID()
        self.name = name
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}
