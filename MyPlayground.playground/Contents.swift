
import PlaygroundSupport
import Foundation

PlaygroundPage.current.needsIndefiniteExecution = true

func after(_ timeInterval: TimeInterval = 0.1, work: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: work)
}

//https://developer.apple.com/documentation/combine/future/3333367-init

final class MyFuture<Output, Failure> where Failure: Error {
    typealias FutureResult = Result<Output, Failure>
    typealias Promise = (FutureResult) -> Void
    
    var result: Result<Output, Failure>?
//    var attempt: (@escaping (FutureResult) -> Void) -> Void
    var callbacks: [(FutureResult) -> Void] = []
    init(_ attemptToFulfill: @escaping (@escaping (FutureResult) -> Void) -> Void) {
//        attempt = attemptToFulfill
        attemptToFulfill(resolve)
    }
    
    func observe(_ onResolved: @escaping (FutureResult) -> Void) {
//        if result == nil {
//            attempt(resolve)
//        }
        callbacks.append(onResolved)
        callCallbacks()
    }
        
    private func resolve(result: FutureResult) {
        self.result = result
        callCallbacks()
    }
    
    private func callCallbacks() {
        guard let result = result else { return }
        callbacks.forEach { callback in
            callback(result)
        }
        callbacks.removeAll()
    }
}

extension MyFuture {
    func myFlatMap<NewValue, NewFailure>(_ onResolved: @escaping (FutureResult) -> MyFuture<NewValue, NewFailure>) -> MyFuture<NewValue, NewFailure> {
        
        MyFuture<NewValue, NewFailure>.init { (newResolve) in
            self.observe { (myValue) in
                onResolved(myValue).observe(newResolve)
            }
        }
        
        
//        return MyFuture<NewValue, NewFailure> { resolve in
//            self.observe { value in
//                onResolved(value).observe(resolve)
//            }
//        }
    }
    
    func myMap<NewValue, NewFailure>(_ onResolved: @escaping (FutureResult) -> Result<NewValue, NewFailure>) -> MyFuture<NewValue, NewFailure> {
        return self.myFlatMap { (value) in
            return MyFuture<NewValue, NewFailure>.init { (resolve) in
                resolve(onResolved(value))
            }
        }
    }
}


struct Speaker {
    func getName(_ completion: @escaping (String?, Error?)->Void) {
        DispatchQueue.main.async {
            completion("MOTORCITY", nil)
        }
    }
    
    var getName: MyFuture<String, Error> {
        return MyFuture<String, Error>.init { (promise) in
            self.getName { (name, error) in
                if let name = name {
                    promise(.success(name))
                } else if let error = error {
                    promise(.failure(error))
                }
            }
        }
    }
}

struct SpeakerSupervisor {
    func getSpeaker(_ completion: @escaping (Speaker?, Error?)->Void) {
        DispatchQueue.main.async {
            completion(Speaker.init(), nil)
        }
    }
    
    var speaker: MyFuture<Speaker, Error> {
        return MyFuture<Speaker, Error>.init { (promise) in
            self.getSpeaker { (speaker, error) in
                if let speaker = speaker {
                    promise(.success(speaker))
                } else if let error = error {
                    promise(.failure(error))
                }
            }
        }
    }
}


let supervisor = SpeakerSupervisor.init()

supervisor.getSpeaker { (speaker, error) in
    speaker?.getName({ (name, error) in
        print(name!)
    })
}

supervisor
    .speaker
    .myFlatMap { try! $0.get().getName }
    .observe {print($0)}

