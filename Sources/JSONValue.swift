// =======================================================
// Janus
// https://github.com/nkirby/Janus
// =======================================================

import Foundation

// =======================================================

public struct JSONValue<Element> {
    public let value: Element?
    public init(value: Element?) {
        self.value = value
    }

// =======================================================
// MARK: - Boxing

    public func box<U>(@noescape block: ((JSONValue<Element>) -> U?)) -> JSONValue<U> {
        return JSONValue<U>(value: block(self))
    }

// =======================================================
// MARK: - Specialization

    public func boolValue() -> Bool? {
        return self.value as? Bool
    }

    public func boolValue(defaultValue defaultValue: Bool) -> Bool {
        return self.value as? Bool ?? defaultValue
    }

#if os(Linux)
    public func stringValue() -> String? {
        //let string = self.value as? NSString
        if let str = self.value as? NSString {
                return String(str)
        }
        return nil
    }
#else
    public func stringValue() -> String? {
        return self.value as? String
    }
#endif

#if os(Linux)
    public func stringValue(defaultValue defaultValue: String) -> String {
        if let str = self.value as? NSString {
            return String(str)
        }
        return defaultValue
    }
#else
    public func stringValue(defaultValue defaultValue: String) -> String {
        return self.value as? String ?? defaultValue
    }
#endif

    public func intValue() -> Int? {
        return self.value as? Int
    }

    public func intValue(defaultValue defaultValue: Int = 0) -> Int {
        return self.value as? Int ?? defaultValue
    }

    public func floatValue() -> Float? {
        return self.value as? Float
    }

    public func floatValue(defaultValue defaultValue: Float = 0.0) -> Float {
        return self.value as? Float ?? defaultValue
    }

    public func jsonDictionaryValue() -> JSONDictionary? {
        return self.value as? JSONDictionary
    }

    public func jsonArrayValue() -> JSONArray? {
        return self.value as? JSONArray
    }

// =======================================================
// MARK: - Coercion

    public func coerceString() -> String {
        if let str = self.value as? String {
            return str
        } else if let val = self.value {
            return "\(val)"
        } else {
            return "\(self.value)"
        }
    }

    public func to<T>(type: T.Type) -> T? {
        return self.value as? T
    }

// =======================================================
// MARK: - Retreival

    public subscript(index: String) -> JSONValue<AnyObject> {
        if let dict = self.value as? [String: AnyObject] {
            return JSONValue<AnyObject>(value: dict[index])
        } else {
            return JSONValue<AnyObject>(value: nil)
        }
    }
}

// =======================================================

extension JSONValue where Element: CustomStringConvertible {
    public func toString(defaultValue defaultValue: String = "") -> String {
        return self.value?.description ?? defaultValue
    }
}

// =======================================================

public enum DateConverting {
    case TimeIntervalSince1970
}

extension JSONValue where Element: FloatLiteralConvertible {
    public func toDate(conversionType type: DateConverting) -> NSDate? {
        switch type {
        case .TimeIntervalSince1970:
            if let val = self.value as? Float {
                let timeInterval = NSTimeInterval(val)
                return NSDate(timeIntervalSince1970: timeInterval)
            } else {
                return nil
            }
        }
    }
}
