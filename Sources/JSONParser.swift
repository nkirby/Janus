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
    public static func model<T: JSONDecodable>(type: T.Type) -> JSONTarget<T> {
        return JSONTarget<T>()
    }

    public static func models<T: JSONDecodable>(type: T.Type) -> JSONTarget<T> {
        return JSONTarget<T>()
    }
}

// =======================================================

public class JSONTarget<T: JSONDecodable> {
    public func from(dict: JSONDictionary) -> T? {
        return T(json: JSONValue(value: dict))
    }

    public func from(strings dict: [String: String]) -> T? {
        var convertedDict = [String: AnyObject]()
        for (key, value) in dict {
            convertedDict[key] = NSString(string: value)
        }
        return T(json: JSONValue(value: convertedDict))
    }

    public func from(arr: JSONArray) -> [T]? {
        var models = [T]()
        for dict in arr {
            if let model = self.from(dict) {
                models.append(model)
            }
        }

        return models
    }
}
