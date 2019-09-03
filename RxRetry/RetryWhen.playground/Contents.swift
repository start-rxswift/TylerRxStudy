import UIKit
import RxSwift


class Timestamp {
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
        return formatter
    }()

    func printTimestamp() -> String {
        return dateFormatter.string(from: Date())
    }
}


enum TestError: Error {
    case test
}


extension ObservableType {
    func retryWhen(
        predicate: @escaping (Error) -> Bool,
        maxRetry: Int,
        timeInterval: DispatchTimeInterval,
        scheduler: SchedulerType
    ) -> Observable<Element> {
        return self.retryWhen { errorObservable -> Observable<Void> in
            return Observable
                .zip(
                    errorObservable.map { error -> Error in
                        if (predicate(error)) { return error }
                        else { throw error }
                    },
                    Observable<Int>.interval(timeInterval, scheduler: scheduler),
                    resultSelector: { error, interval in
                        print("\(Timestamp().printTimestamp()): retry count: \(interval)")
                        if interval >= maxRetry { throw error }
                        return ()
                    })
        }
    }
}

//Observable.just(3)
//    .map { i -> Int in
//        if i < 2 { throw TestError.test }
//        else { return i }
//    }
Observable.just(1)
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
        timeInterval: RxTimeInterval.milliseconds(1000),
        scheduler: MainScheduler.asyncInstance
    )
    .debug("retryWhen")
    .subscribe(onNext: { _ in
        
//        print("onNext: \($0)")
    }, onError: { _ in
        })

