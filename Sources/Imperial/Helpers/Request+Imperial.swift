import Vapor

extension Request {
    func fetch<T: FederatedCreatable>(_ model: T.Type)throws -> T {
        if let new = self.storage["imperial-\(model)"] {
            return new as! T
        }
        
        let token = try model.tokenPrefix + self.getAccessToken()
        let uri = model.dataUri
        let noJson = ImperialError.missingJSONFromResponse(uri)
        
        let response = try drop.client.get(uri, [.authorization: token])
        let new = try model.create(with: response.json ?? noJson)
        
        self.storage["imperial-\(model)"] = new
        return new
    }
}
