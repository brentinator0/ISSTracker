//  This file was automatically generated and should not be edited.

import Apollo

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