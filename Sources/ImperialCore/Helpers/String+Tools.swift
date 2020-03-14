import Foundation
import RoutingKit

extension String {
    
    var bytes: [UInt8] { .init(utf8) }
    
	var pathComponents: [PathComponent] {
		var pathComponentArray = [PathComponent]()
		if let components = URL(string: self)?.pathComponents {
			for item in components where item != "/" {
				pathComponentArray.append(PathComponent(stringLiteral: item))
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
