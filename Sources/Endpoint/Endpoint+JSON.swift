import Foundation

public extension Endpoint {
    typealias JSON = AnyEndpointCoder<JSONEncoder, JSONDecoder>
}

public extension Endpoint where Coder.Decoder == JSONDecoder, Response: Decodable {

    static func decode(from data: Data, with decoder: Coder.Decoder) throws -> Response {
        try decoder.decode(Response.self, from: data)
    }
}

public extension Endpoint where Coder.Encoder == JSONEncoder, Request: Encodable {

    static var headers: Headers { { _ in
        [
            .accept: "application/json",
            .contentType: "application/json"
        ]
    } }

    static var post: HttpMethod { { input, encoder in .post(try encoder.encode(input)) } }
}
