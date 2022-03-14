import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct EndpointPublisherTask<E: Endpoint> {
    let start: (E.Request) -> AnyPublisher<E.Response, APIError>
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Endpoint {
    static func requestTask(
        with session: URLSession,
        encoder: Coder.Encoder,
        decoder: Coder.Decoder,
        config: EndpointRequestConfig,
        baseHeaders: [EndpointHeaderKey: String] = [:],
        baseQueryItems: [String: String] = [:]
    ) -> EndpointPublisherTask<Self> {
        .init { input in
            var cancel: Cancellable = SimpleCancellable()
            return Future { fullFill in
                cancel = self.requestTask(
                    with: session,
                    encoder: encoder,
                    decoder: decoder,
                    config: config
                ).start(input, fullFill)
            }
            .handleEvents(receiveCancel: cancel.cancel)
            .eraseToAnyPublisher()
        }
    }
}
