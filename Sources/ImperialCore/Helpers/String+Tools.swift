import Foundation

extension String.UTF8View: DataProtocol {
    public var regions: CollectionOfOne<[UInt8]> { Array(self).regions }
}

extension Substring.UTF8View: DataProtocol {
    public var regions: CollectionOfOne<[UInt8]> { Array(self).regions }
}
