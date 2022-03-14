import Foundation

protocol Cancellable {
    func cancel()
}

struct SimpleCancellable: Cancellable {
    private let sink: () -> Void

    init(sink: @escaping () -> Void = {}) {
        self.sink = sink
    }

    func cancel() {
        self.sink()
    }
}

final class DeinitCancellable: Cancellable, Identifiable {

    var id: ObjectIdentifier { ObjectIdentifier(self) }

    private let cancellable: Cancellable

    init(cancellable: Cancellable) {
        self.cancellable = cancellable
    }

    deinit {
        cancel()
    }

    func cancel() {
        self.cancellable.cancel()
    }
}

extension Cancellable {
    func autoCancel() -> DeinitCancellable { .init(cancellable: self) }
}
