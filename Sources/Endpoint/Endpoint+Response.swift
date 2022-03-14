import Foundation

public extension Endpoint {
    typealias EmptyResponse = Void
}

public extension Endpoint where Response == Void {
    static func decode(from data: Data, with decoder: Coder.Decoder) throws -> EmptyResponse {}
}
