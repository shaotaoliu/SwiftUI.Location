import Foundation

class ViewModel: NSObject, ObservableObject {
    @Published var hasError = false
    @Published var error: LocationError? = nil {
        didSet {
            hasError = error != nil
        }
    }
}
