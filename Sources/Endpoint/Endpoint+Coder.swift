import Foundation

public protocol EndpointCoder {
    associatedtype Encoder
    associatedtype Decoder
}

public enum AnyEndpointCoder<Encoder, Decoder>: EndpointCoder {
    public typealias Encoder = Encoder
    public typealias Decoder = Decoder
}
