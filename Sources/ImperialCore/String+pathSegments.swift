import Foundation
import RoutingKit

extension String {
    var pathSegments: [PathComponent] {
        if let components = URL(string: self)?.pathComponents {
            var pathSegments: [PathComponent] = []

            for component in components where component != "/" {
                pathSegments.append(PathComponent(stringLiteral: component))
            }

            return pathSegments
        } else {
            return self.pathComponents
        }
    }
}
