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

[Kotlin coroutine](https://github.com/Kotlin/kotlinx.coroutines/blob/master/docs/coroutine-context-and-dispatchers.md#coroutine-context-and-dispatchers)

`Unconfined` 의미로 지정된 Thread가 없다는 뜻이다.
> 다음으로 지정되어 실행되는 Thread에 상속된다는 것이다.

1. Unconfined
2. Default
