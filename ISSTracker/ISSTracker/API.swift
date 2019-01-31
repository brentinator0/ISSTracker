//  This file was automatically generated and should not be edited.

import Apollo

public enum _ModelMutationType: RawRepresentable, Equatable, Hashable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case created
  case updated
  case deleted
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "CREATED": self = .created
      case "UPDATED": self = .updated
      case "DELETED": self = .deleted
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .created: return "CREATED"
      case .updated: return "UPDATED"
      case .deleted: return "DELETED"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: _ModelMutationType, rhs: _ModelMutationType) -> Bool {
    switch (lhs, rhs) {
      case (.created, .created): return true
      case (.updated, .updated): return true
      case (.deleted, .deleted): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public final class IssLocationQuery: GraphQLQuery {
  public let operationDefinition =
    "query ISSLocation {\n  ISSLocation {\n    __typename\n    longitude\n    latitude\n    timestamp\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("ISSLocation", type: .object(IssLocation.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(issLocation: IssLocation? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "ISSLocation": issLocation.flatMap { (value: IssLocation) -> ResultMap in value.resultMap }])
    }

    /// getisslocation
    public var issLocation: IssLocation? {
      get {
        return (resultMap["ISSLocation"] as? ResultMap).flatMap { IssLocation(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "ISSLocation")
      }
    }

    public struct IssLocation: GraphQLSelectionSet {
      public static let possibleTypes = ["ISSLocationPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("longitude", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(String.self)),
        GraphQLField("timestamp", type: .scalar(Int.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(longitude: String? = nil, latitude: String? = nil, timestamp: Int? = nil) {
        self.init(unsafeResultMap: ["__typename": "ISSLocationPayload", "longitude": longitude, "latitude": latitude, "timestamp": timestamp])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var longitude: String? {
        get {
          return resultMap["longitude"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "longitude")
        }
      }

      public var latitude: String? {
        get {
          return resultMap["latitude"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "latitude")
        }
      }

      public var timestamp: Int? {
        get {
          return resultMap["timestamp"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "timestamp")
        }
      }
    }
  }
}

public final class CreateMessageWithTextMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation CreateMessageWithText($text: String!, $lat: String!, $long: String!, $country: String!) {\n  createMessage(text: $text, location: {latitude: $lat, longitude: $long, country: $country}) {\n    __typename\n    id\n    text\n    location {\n      __typename\n      latitude\n      longitude\n      country\n    }\n  }\n}"

  public var text: String
  public var lat: String
  public var long: String
  public var country: String

  public init(text: String, lat: String, long: String, country: String) {
    self.text = text
    self.lat = lat
    self.long = long
    self.country = country
  }

  public var variables: GraphQLMap? {
    return ["text": text, "lat": lat, "long": long, "country": country]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createMessage", arguments: ["text": GraphQLVariable("text"), "location": ["latitude": GraphQLVariable("lat"), "longitude": GraphQLVariable("long"), "country": GraphQLVariable("country")]], type: .object(CreateMessage.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createMessage: CreateMessage? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createMessage": createMessage.flatMap { (value: CreateMessage) -> ResultMap in value.resultMap }])
    }

    public var createMessage: CreateMessage? {
      get {
        return (resultMap["createMessage"] as? ResultMap).flatMap { CreateMessage(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createMessage")
      }
    }

    public struct CreateMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("text", type: .nonNull(.scalar(String.self))),
        GraphQLField("location", type: .nonNull(.object(Location.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, text: String, location: Location) {
        self.init(unsafeResultMap: ["__typename": "Message", "id": id, "text": text, "location": location.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var text: String {
        get {
          return resultMap["text"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "text")
        }
      }

      public var location: Location {
        get {
          return Location(unsafeResultMap: resultMap["location"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "location")
        }
      }

      public struct Location: GraphQLSelectionSet {
        public static let possibleTypes = ["Location"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
          GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
          GraphQLField("country", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(latitude: String, longitude: String, country: String) {
          self.init(unsafeResultMap: ["__typename": "Location", "latitude": latitude, "longitude": longitude, "country": country])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var latitude: String {
          get {
            return resultMap["latitude"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "latitude")
          }
        }

        public var longitude: String {
          get {
            return resultMap["longitude"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "longitude")
          }
        }

        public var country: String {
          get {
            return resultMap["country"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "country")
          }
        }
      }
    }
  }
}

public final class CreateMessageSubscription: GraphQLSubscription {
  public let operationDefinition =
    "subscription createMessage {\n  Message(filter: {mutation_in: [CREATED]}) {\n    __typename\n    mutation\n    node {\n      __typename\n      id\n      text\n      location {\n        __typename\n        latitude\n        longitude\n        country\n      }\n    }\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("Message", arguments: ["filter": ["mutation_in": ["CREATED"]]], type: .object(Message.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(message: Message? = nil) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "Message": message.flatMap { (value: Message) -> ResultMap in value.resultMap }])
    }

    public var message: Message? {
      get {
        return (resultMap["Message"] as? ResultMap).flatMap { Message(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "Message")
      }
    }

    public struct Message: GraphQLSelectionSet {
      public static let possibleTypes = ["MessageSubscriptionPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("mutation", type: .nonNull(.scalar(_ModelMutationType.self))),
        GraphQLField("node", type: .object(Node.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(mutation: _ModelMutationType, node: Node? = nil) {
        self.init(unsafeResultMap: ["__typename": "MessageSubscriptionPayload", "mutation": mutation, "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var mutation: _ModelMutationType {
        get {
          return resultMap["mutation"]! as! _ModelMutationType
        }
        set {
          resultMap.updateValue(newValue, forKey: "mutation")
        }
      }

      public var node: Node? {
        get {
          return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "node")
        }
      }

      public struct Node: GraphQLSelectionSet {
        public static let possibleTypes = ["Message"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("text", type: .nonNull(.scalar(String.self))),
          GraphQLField("location", type: .nonNull(.object(Location.selections))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, text: String, location: Location) {
          self.init(unsafeResultMap: ["__typename": "Message", "id": id, "text": text, "location": location.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var text: String {
          get {
            return resultMap["text"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "text")
          }
        }

        public var location: Location {
          get {
            return Location(unsafeResultMap: resultMap["location"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "location")
          }
        }

        public struct Location: GraphQLSelectionSet {
          public static let possibleTypes = ["Location"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
            GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
            GraphQLField("country", type: .nonNull(.scalar(String.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(latitude: String, longitude: String, country: String) {
            self.init(unsafeResultMap: ["__typename": "Location", "latitude": latitude, "longitude": longitude, "country": country])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var latitude: String {
            get {
              return resultMap["latitude"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "latitude")
            }
          }

          public var longitude: String {
            get {
              return resultMap["longitude"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "longitude")
            }
          }

          public var country: String {
            get {
              return resultMap["country"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "country")
            }
          }
        }
      }
    }
  }
}

public final class RetreiveLastMessagesQuery: GraphQLQuery {
  public let operationDefinition =
    "query RetreiveLastMessages($numOfMessages: Int) {\n  allMessages(last: $numOfMessages) {\n    __typename\n    id\n    text\n    location {\n      __typename\n      latitude\n      longitude\n      country\n    }\n  }\n}"

  public var numOfMessages: Int?

  public init(numOfMessages: Int? = nil) {
    self.numOfMessages = numOfMessages
  }

  public var variables: GraphQLMap? {
    return ["numOfMessages": numOfMessages]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("allMessages", arguments: ["last": GraphQLVariable("numOfMessages")], type: .nonNull(.list(.nonNull(.object(AllMessage.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(allMessages: [AllMessage]) {
      self.init(unsafeResultMap: ["__typename": "Query", "allMessages": allMessages.map { (value: AllMessage) -> ResultMap in value.resultMap }])
    }

    public var allMessages: [AllMessage] {
      get {
        return (resultMap["allMessages"] as! [ResultMap]).map { (value: ResultMap) -> AllMessage in AllMessage(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: AllMessage) -> ResultMap in value.resultMap }, forKey: "allMessages")
      }
    }

    public struct AllMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("text", type: .nonNull(.scalar(String.self))),
        GraphQLField("location", type: .nonNull(.object(Location.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, text: String, location: Location) {
        self.init(unsafeResultMap: ["__typename": "Message", "id": id, "text": text, "location": location.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var text: String {
        get {
          return resultMap["text"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "text")
        }
      }

      public var location: Location {
        get {
          return Location(unsafeResultMap: resultMap["location"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "location")
        }
      }

      public struct Location: GraphQLSelectionSet {
        public static let possibleTypes = ["Location"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
          GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
          GraphQLField("country", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(latitude: String, longitude: String, country: String) {
          self.init(unsafeResultMap: ["__typename": "Location", "latitude": latitude, "longitude": longitude, "country": country])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var latitude: String {
          get {
            return resultMap["latitude"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "latitude")
          }
        }

        public var longitude: String {
          get {
            return resultMap["longitude"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "longitude")
          }
        }

        public var country: String {
          get {
            return resultMap["country"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "country")
          }
        }
      }
    }
  }
}