import Foundation

public protocol Endpoint {
  associatedtype Request
  associatedtype Response

  associatedtype Coder: EndpointCoder

  typealias Path = (Request) -> String
  static var path: Path { get }

  typealias Headers = (Request) -> [EndpointHeaderKey: String]
  static var headers: Headers { get }

  typealias HttpMethod = (Request, Coder.Encoder) throws -> EndpointMethod
  static var method: HttpMethod { get }

  typealias QueryItems = (Request) -> [String: String]
  static var queryItems: QueryItems { get }

  static func decode(from data: Data, with decoder: Coder.Decoder) throws -> Response
}
