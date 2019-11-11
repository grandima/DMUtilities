
import PlaygroundSupport
import Foundation


//https://gist.github.com/felginep/039ca3b21e4f0cabb1c06126d9164680
class Promise<Value> {

    enum State<T> {
        case pending
        case resolved(T)
    }

    private var state: State<Value> = .pending
    private var callbacks: [(Value) -> Void] = []

    init(executor: (_ resolve: @escaping (Value) -> Void) -> Void) {
        executor(resolve)
    }

    // observe
    public func then(_ onResolved: @escaping (Value) -> Void) {
        callbacks.append(onResolved)
        triggerCallbacksIfResolved()
    }

    // flatMap
    public func then<NewValue>(_ onResolved: @escaping (Value) -> Promise<NewValue>) -> Promise<NewValue> {
        return Promise<NewValue> { resolve in
            then { value in
                onResolved(value).then(resolve)
            }
        }
    }

    // map
    public func then<NewValue>(_ onResolved: @escaping (Value) -> NewValue) -> Promise<NewValue> {
        return then { value in
            return Promise<NewValue> { resolve in
                resolve(onResolved(value))
            }
        }
    }

    private func resolve(value: Value) {
        updateState(to: .resolved(value))
    }

    private func updateState(to newState: State<Value>) {
        guard case .pending = state else { return }
        state = newState
        triggerCallbacksIfResolved()
    }

    private func triggerCallbacksIfResolved() {
        guard case let .resolved(value) = state else { return }
        callbacks.forEach { callback in
            callback(value)
        }
        callbacks.removeAll()
    }
}

//https://developer.apple.com/documentation/combine/future/3333367-init
final class MyFuture<Output, Failure> where Failure: Error {
    typealias FutureResult = Result<Output, Failure>
    typealias Promise = (FutureResult) -> Void
    
    var result: Result<Output, Failure>?
    var callbacks: [(FutureResult) -> Void] = []
    init(_ attemptToFulfill: @escaping (@escaping (FutureResult) -> Void) -> Void) {
        attemptToFulfill(resolve)
    }
    
    func observe(_ onResolved: @escaping (FutureResult) -> Void) {
        callbacks.append(onResolved)
        callCallbacks
    }
    
    func myFlatMap<NewValue>(_ onResolved: @escaping (FutureResult) -> MyFuture<NewValue, Failure>) -> MyFuture<NewValue, Failure> {
        return MyFuture<NewValue, Failure> { resolve in
            self.observe { value in
                onResolved(value).observe(resolve)
            }
        }
    }
    
    func myMap<NewValue>(_ onResolved: @escaping (FutureResult) -> Result<NewValue, Failure>) -> MyFuture<NewValue, Failure> {
        observe { (<#Result<Output, Error>#>) in
            <#code#>
        }
        return then { value in
            return Promise<NewValue> { resolve in
                resolve(onResolved(value))
            }
        }
    }
    
    private func resolve(result: FutureResult) {
        callCallbacks
    }
    
    private func callCallbacks() {
        guard let result = result else { return }
        callbacks.forEach { callback in
            callback(result)
        }
        callbacks.removeAll()
    }
}

