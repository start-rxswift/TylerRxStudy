```
enum TestError: Error {
    case test
}
```

```
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
```


```
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


```


결과: 
```
2019-09-03 16:56:13.589: retryWhen -> subscribed
2019-09-03 16:56:15.109 : retry count: 0
2019-09-03 16:56:16.609 : retry count: 1
2019-09-03 16:56:18.109 : retry count: 2
2019-09-03 16:56:19.608 : retry count: 3
2019-09-03 16:56:19.609: retryWhen -> Event error(test)
2019-09-03 16:56:19.609: retryWhen -> isDisposed
```
