// =======================================================
// Janus
// https://github.com/nkirby/Janus
// =======================================================

import Foundation

// =======================================================

public typealias JSONDictionary = [String: AnyObject]
public typealias JSONArray = [JSONDictionary]

public protocol JSONDecodable {
    init?(json: JSONValue<JSONDictionary>)
}

// =======================================================

public class JSONParser {
    public static func model<T: JSONDecodable>(dict: JSONDictionary, ofType type: T.Type) -> T? {
        return T(json: JSONValue(value: dict))
    }
    
    public static func models<T: JSONDecodable>(arr: JSONArray, ofType type: T.Type) -> [T]? {
        var models = [T]()
        for dict in arr {
            if let model = self.model(dict, ofType: type) {
                models.append(model)
            }
        }
        return models
    }
}
