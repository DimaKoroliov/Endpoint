import Foundation

public enum EndpointMethod {
    case get
    case post(Data)
}

public extension EndpointMethod {

    var httpMethod: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

public extension Endpoint {
    static var get: HttpMethod { { _,_ in .get } }
    static var post: HttpMethod { { _, _ in .post(Data()) } }
}
