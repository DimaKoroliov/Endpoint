import Foundation

public enum APIError: Error {
    case encode(Error)
    case decode(Error)
    case invalid(path: String)
    case badResponse(code: Int)
}
