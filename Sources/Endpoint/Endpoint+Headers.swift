import Foundation

public struct EndpointHeaderKey: Hashable, ExpressibleByStringLiteral {
    let key: String

    public init(unicodeScalarLiteral: UnicodeScalar) {
        key = String(unicodeScalarLiteral)
    }

    public init(extendedGraphemeClusterLiteral: Character) {
        key = String(extendedGraphemeClusterLiteral)
    }

    public init(stringLiteral: String) {
        key = stringLiteral
    }
}

public extension EndpointHeaderKey {
    static let accept: Self = "Accept"
    static let contentType: Self = "Content-Type"
}
