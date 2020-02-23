//
//  RoutesBuilder+Tools.swift
//  Server
//
//  Created by Maxim Anisimov on 23.02.2020.
//

import Vapor

extension RoutesBuilder {
    @discardableResult
    public func get<Response>(
        _ path: [PathComponent],
        use closure: @escaping (Request) throws -> Response
    ) -> Route
        where Response: ResponseEncodable {
        return self.on(.GET, path, use: closure)
    }
}
