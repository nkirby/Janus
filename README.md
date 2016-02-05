## Janus

What the world doesn't need is another Swift JSON parser, yet here we are. 

The entire goal of Janus is to provide the thinnest level of safety to JSON parsing. It should be fast, and generally feature free by design. It also doesn't impose much in the way of usage guidelines or restrictions on your code - what you do with Janus's parsed `JSONValue` is up to you.

--

### Usage

#### JSONParser

Assuming we have a JSON Dictionary `[String: AnyObject]`, that we want to convert into a model:

```
import Janus

let dict = getJSONDictionary()	// or whatever.
let model = JSONParser.model(ModelType.self)
					.from(dict)

// model will be a ModelType?
```

The Janus JSONParser is agnostic to how you actually store the parsed JSON. All it requires is that the type passed into `.model()` conform to `JSONDecodable`.

--

#### JSONDecodable

JSONDecodable is a simple protocol requiring a single failable initializer.

```
public protocol JSONDecodable {
    init?(json: JSONValue<JSONDictionary>)
}
```

Where `JSONDictionary` is a typealias for `[String: AnyObject]`, and `JSONValue` is a boxed representation of the JSON that'll help you parse values out safely.

--

#### init?(json: ...)

In your model class or struct, implement the `init?(json: JSONValue<JSONDictionary>) method. 

```
import Janus

internal struct ModelType: JSONDecodable {
	let title: String
	let boolVal: Bool
	
	init?(json: JSONValue<JSONDictionary>) {
		self.title = json["title"].stringValue(defaultValue: "")
		self.boolVal = json["bool"].boolValue(defaultValue: false)
	}
}
```

If the value doesn't exist, or isn't of the right type, the passed `defaultValue` will be used.

Nested values also work. You can safely chain these calls, where if any of the values are missing, the defaultValue will be returned.

```
import Janus

internal struct ModelType: JSONDecodable {
	let itemCount: Int
	
	init?(json: JSONValue<JSONDictionary>) {
		self.itemCount = json["items"]["count"].intValue(defaultValue: 0)
	}
}
```
