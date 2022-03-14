import Foundation

public extension Endpoint {
    static func const(_ path: String) -> Path { { _ in path } }
}

public extension Endpoint where Request == URL {
    static var path: Path { { $0.path } }
}
