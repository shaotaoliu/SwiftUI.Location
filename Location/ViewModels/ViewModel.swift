import Foundation

class ViewModel: NSObject, ObservableObject {
    @Published var hasError = false
    @Published var errorMessage: String? = nil {
        didSet {
            hasError = errorMessage != nil
        }
    }
}
