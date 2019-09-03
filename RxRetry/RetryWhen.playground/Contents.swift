import UIKit
import RxSwift

enum TestError: Error {
    case test
}


extension ObservableType {
    func retryWhen(
        predicate: @escaping (Error) -> Bool,
        maxRetry: Int,
        timeInterval: DispatchTimeInterval,
        scheduler: SchedulerType
        ) -> Observable<Element>  {
        return self.retryWhen { errorObservable -> Observable<Void> in
            return Observable
                .zip(
                    errorObservable.map { error -> Error in
                        if (predicate(error)) { return error }
                        else { throw error }
                    },
                    Observable<Int>.interval(timeInterval, scheduler: scheduler),
                    resultSelector: { error, interval in
                        print("RetryWhen: \(error) \(interval)")
                        if interval >= maxRetry { throw error }
                        return ()
                })
        }
    }
}

Observable.just("Test")
    .map { _ in throw TestError.test }
    .retryWhen(
        predicate: {
            switch $0 {
            case TestError.test:
                return true
            default:
                return false
            }
    },
        maxRetry: 3,
        timeInterval: RxTimeInterval.milliseconds(1500),
        scheduler: MainScheduler.asyncInstance
    )
    .debug("retryWhen")
    .subscribe(onNext: {
        print("onNext: \($0)")
    }, onError: {
        print("onError: \($0)")
    })
        
