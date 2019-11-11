
import PlaygroundSupport
import Foundation


func after(_ timeInterval: TimeInterval = 0.1, work: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: work)
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
        return self.myFlatMap { (value) in
            return MyFuture<NewValue, Failure>.init { (resolve) in
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


struct Speaker {
    func getName(_ completion: @escaping (String?, Error?)->Void) {
        DispatchQueue.main.async {
            completion("Boom 3", nil)
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
    func getSpeaker(_ completion: @escaping (Speaker, Error?)->Void) {
        DispatchQueue.main.async {
            completion(Speaker.init(), nil)
        }
    }
    
    func speaker: MyFuture<Speaker, Error> {
        return MyFuture<String, Error>.init { (promise) in
            get
        }
    }
}

func checkifTwoNamesAreEqual(speaker1: Speaker, speaker2: Speaker) -> MyFuture {
    
}

func fetchUser(id: Int) -> MyFuture<Speaker, Error> {
    return MyFuture { resolve in
        after(0.1) {
            resolve(.success(User(id: id, name: "M.D.")))
        }
    }
}

fetchUser(id: 5)
