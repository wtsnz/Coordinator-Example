import Foundation

public struct Services {
    
    public let dataService: DataService
    
    public init() {
        self.dataService = DataService()
    }
}

public struct Order {
    public let drinkType: String
    public let snackType: String
    
    public init(drinkType: String, snackType: String) {
        self.drinkType = drinkType
        self.snackType = snackType
    }
    
}

public class DataService {
    
    public var orders: [Order] = []
    
}
