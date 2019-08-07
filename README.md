# subscribeOn

Main Thread로 실행되는 Observable `subscribeOn` 을 지정하여도 동작하지 않는다.
```
        subscribeOnButton.rx.tap
            .subscribeOn(SerialDispatchQueueScheduler(internalSerialQueueName: "test"))
            .subscribe(onNext: {
                print("subscribeOnButton ThreadName: \(threadName())")
            })
```

```
subscribeOnButton ThreadName: main
```

관련된 문서를 찾기 어려웠지만 한가지 추측을 할 수 있었다.

# 추측
`subscribeOn` 은 지정되지 않은 Thread에만 적용될 수 있다는 것이다.

### Kotlin Coroutine
[Kotlin coroutine](https://github.com/Kotlin/kotlinx.coroutines/blob/master/docs/coroutine-context-and-dispatchers.md#coroutine-context-and-dispatchers)

`Unconfined` 의미로 지정된 Thread가 없다는 뜻이다.
> 다음으로 지정되어 실행되는 Thread에 상속된다는 것이다.

1. Unconfined
2. Default

위 순서로 실행된다면 최종적으로 `Default` 로 상속되어 실행된다는 것이다.

------ Unconfined ------- Default --------|--->

### Unconfined Thread
```
Observable.just(1)
            .subscribeOn(SerialDispatchQueueScheduler(internalSerialQueueName: "subs"))
```
위 코드를 실행하면 `subs` 라는 Thread로 실행되는 것을 확인할 수 있다. 


### Thread 상속
조금 더 복잡한 상황을 만들어 보기로 하자!
```
 Observable.just(1)
            .concatMap { _ in self.createObservable("concatMap") }
            .do(onNext: { _ in
                print("concatMap ThreadName: \(threadName())")
            })
            .flatMap { _ in self.createObservable("flatMap") }
            .do(onNext: { _ in
                print("flatMap ThreadName: \(threadName())")
            })
            .subscribe(onNext: { _ in
                print("tapObservableSubscribeOn ThreadName: \(threadName())")
            })
    
func createObservable(_ with: String) -> Observable<Int> {
return Observable.just(1).subscribeOn(SerialDispatchQueueScheduler(internalSerialQueueName: with))
}
```

```
concatMap ThreadName: concatMap
flatMap ThreadName: flatMap
tapObservableSubscribeOn ThreadName: flatMap
```
`subscribeOn은 위치와 상관없이 한번만 쓰면 된다` 라는 설명을 들었지만 새로운 Observable Stream 마다 적용되는 것을 확인할 수 있다. 

이것을 통해 `Thread 상속`이 되는 것을 알았다.
