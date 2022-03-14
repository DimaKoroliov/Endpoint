import Foundation

public struct EndpointRequestConfig {
    let scheme: String?
    let host: String
    let port: Int?
}

public struct EndpointCallbackTask<E: Endpoint> {
    typealias Callback = (Result<E.Response, APIError>) -> Void
    let start: (E.Request, @escaping Callback) -> Cancellable
}

public extension Endpoint {
    
    static func makeRequest(
        input: Request,
        encoder: Coder.Encoder,
        decoder: Coder.Decoder,
        config: EndpointRequestConfig
    ) throws -> URLRequest {
        let path = self.path(input)
        var urlComponents = URLComponents(config: config)
        urlComponents.path = path

        let queryItems = self.queryItems(input).map { URLQueryItem(name: $0.key, value: $0.value) }
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            throw APIError.invalid(path: path)
        }

        var request = URLRequest(url: url)
        let headers = self.headers(input).map { ($0.key.key, $0.value) }
        request.allHTTPHeaderFields = Dictionary(uniqueKeysWithValues: headers)

        let methodData = try self.method(input, encoder)
        request.httpMethod = methodData.httpMethod

        switch methodData {
        case .get:
            break
        case let .post(body):
            request.httpBody = body
        }

        return request
    }

    static func requestTask(
        with session: URLSession,
        encoder: Coder.Encoder,
        decoder: Coder.Decoder,
        config: EndpointRequestConfig
    ) -> EndpointCallbackTask<Self> {
        .init { input, callback in
            do {
                let request = try makeRequest(
                    input: input,
                    encoder: encoder,
                    decoder: decoder,
                    config: config
                )
                let task = session.dataTask(with: request) { data, response, error in
                    guard let code = response?.code else {
                        callback(.failure(.badResponse(code: -1)))
                        return
                    }

                    guard
                        (200...299).contains(code),
                        let data = data
                    else {
                        callback(.failure(.badResponse(code: code)))
                        return
                    }

                    do {
                        let response = try decode(from: data, with: decoder)
                        callback(.success(response))
                    } catch {
                        callback(.failure(.decode(error)))
                    }
                }

                task.resume()

                return SimpleCancellable(sink: task.cancel)
            } catch {
                callback(.failure(.encode(error)))
            }

            return SimpleCancellable()
        }
    }
}

private extension URLResponse {
    var code: Int? {
        return (self as? HTTPURLResponse)?.statusCode
    }
}

private extension URLComponents {

    init(config: EndpointRequestConfig) {
        self.init()
        self.scheme = config.scheme
        self.host = config.host
        self.port = config.port
    }
}
