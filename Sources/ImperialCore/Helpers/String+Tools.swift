import Foundation
import RoutingKit

extension String {    
    func pathComponents(grouped: [PathComponent] = []) -> [PathComponent] {
        var pathComponentArray = [PathComponent]()
        if let url = URL(string: self) {
            pathComponentArray = url
                .pathComponents
                .filter{ $0 != "/" }
                .map{ .init(stringLiteral: $0) }
            if !grouped.isEmpty {
                var indexes = IndexSet()
                for (i, groupComponent) in grouped.enumerated() {
                    if i < pathComponentArray.count && groupComponent == pathComponentArray[i] {
                        indexes.insert(i)   // duplicate at index
                    } else {
                        break   // after first component mismatch
                    }
                }
                // remove components at indexes in reverse order
                for index in indexes.reversed() {
                    pathComponentArray.remove(at: index)
                }
            }
        }
        return pathComponentArray
    }
}

extension String.UTF8View: DataProtocol {
    public var regions: CollectionOfOne<Array<UInt8>> { Array(self).regions }
}

extension Substring.UTF8View: DataProtocol {
    public var regions: CollectionOfOne<Array<UInt8>> { Array(self).regions }
}
