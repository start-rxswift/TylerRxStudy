# Binder
RxCocoa Binding을 사용하면 다음과 같이 값의 변화에 따라 화면의 일부 View에 쉽게 Binding 할 수 있습니다.

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FdvmbxT%2FbtqxS5Xu719%2Fgp2E6jedcDEsbfA3n5kIWK%2Fimg.png" alt="alt text" width="360" height="whatever">

위에 그림 예제는 
ViewModel(myObservable View의 속성을 가지는 Observable) 과 View(myLabel의 Text)는 Databinding 을 사용하여 View의 변화를 주고 있습니다.

 

### 왜 Binder를 사용할까요?
MVVM 의 DataBinding 을 구현하기 위해서는 Binder 가 필요하기 때문입니다.

 
위에 예제에서는 `text` 의 sink 를 통해서 UILabel의 text를 업데이트 할 수 있습니다.


#### [UILabel+Rx.swift](https://github.com/ReactiveX/RxSwift/blob/master/RxCocoa/iOS/UILabel%2BRx.swift)

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FITi4J%2FbtqxXailJ9L%2F0pC6DJUTkjnkvewCTU7c9k%2Fimg.png" alt="alt text" width="360" height="whatever">

####  Stream의 용어에서는 Source, Sink 두 용어가 있습니다. 

Source: 원본 즉 이벤트 발생 개념

Sink: 목적지의 개념

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FcIMxwD%2FbtqxXKqcwQz%2FKJXKLLQTinAM1lbZNl3bp0%2Fimg.png" alt="alt text" width="360" height="whatever">


#### [RxCocoa Binder.swift](https://github.com/ReactiveX/RxSwift/blob/master/RxCocoa/Common/Binder.swift)

* `Binder`는 대상을 유지하지 않으며 대상이 해제 된 경우 요소가 Binding되지 않습니다.

* 기본적으로는 메인 스케쥴러에서 Binding 됩니다.

 

인터페이스 바인딩 규칙:

1. Error 는 Binding 할 수 없습니다.

 - (Debug 에서는 FatalError가 발생, Release 는 Log 로 출력됨)

2. 특정 스케줄러에서 바인딩이 수행되도록 합니다.


# ControlEvent 
가장 기본적인 예제로 시작하도록 하겠습니다. 

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FbJlWUM%2FbtqxWKRJDLm%2FUw2bhM8v13wfkOJ1HZBkck%2Fimg.png" alt="alt text" width="360" height="whatever">


UIButton.rx.tap 내부 코드

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FDibQk%2FbtqxS54lnTA%2FqDXkYBbn3OKTvGfsc77XW1%2Fimg.png" alt="alt text" width="360" height="whatever">

`touchUpInside` 이벤트를 `tap`이라는 이름으로 Wrapping 하고 있는 것을 알 수 있습니다.

touchUpInside 는 어디서 나온 것 일까요?


#### [UIControl Event](https://developer.apple.com/documentation/uikit/uicontrol/event)

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FdacI9u%2FbtqxUqmDShL%2FkM8hhl1vAeK0gktyA8d440%2Fimg.png" alt="alt text" width="360" height="whatever">


#### UIControl
우리가 흔히 쓰는  addTarget(_:action:for:) 은 Target-Action 메커니즘이며 UIControl 과 앱의 상호작용을 연결합니다.

[RxCocoa ControlEvent.swift](https://github.com/ReactiveX/RxSwift/blob/master/RxCocoa/Traits/ControlEvent.swift)

UI 이벤트를 나타내는 Observable/ ObservableType 특징

1. 절대 실패하지 않음.
2. subscribe 시 초기값을 보내지 않음
3. Control 이 해제될 때는 Complete 이벤트를 보냄
4. Error 를 방출하지 않음

 
