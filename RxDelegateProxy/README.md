# RxDelegateProxy

MKLocalSearchCompleter 예제를 기반으로 준비하였습니다!


[MKLocalSearchCompleter](https://developer.apple.com/documentation/mapkit/mklocalsearchcompleter) 는 아래 그림과 같이

`delegate` = self 로 Delegate 를 설정할 수 있습니다.
 
 <img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FbHrXN8%2FbtqxXKqqAj5%2F1JyTHYd6gpJ8jEds7vmjR1%2Fimg.png" alt="alt text" width="480" height="whatever">
 
### Delegate 방법
 <img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FKLLw8%2FbtqxVfE5Zey%2Fkm7kwQp0JML9B4KKfzBClK%2Fimg.png" alt="alt text" width="360" height="whatever">
 
그러나 객체간 비동기 통신을 처리하는데 있어서 CallBack Hell 을 불러일으킵니다.

가독성이 떨어지며 코드의 흐름을 파악하기 위한 디버깅이 어려워집니다.


### RxDelegateProxy 방법
<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FdSl3uv%2FbtqxUqtAHVy%2FGyXKHk3SUoLlyBQLDonPt0%2Fimg.png" alt="alt text" width="360" height="whatever">

RxSwift 로 작성하면 이해하기 코드로 탄생할 수 있습니다!



### 그런데... Delegate Proxy가 모지...?

#### Delegate?

Cocoa Framework 를 경험하면서 [Delegate](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/Delegation.html) 의 용어를 자주 들어보셨을 겁니다.

Foundation, UIKit, AppKit 및 기타 Cocoa 및 Cocoa Touch 프레임 워크에는 Delegate의 예가 많이 있습니다.

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FmE9zh%2FbtqxXJSzcb0%2FafMJzzydsojwHY0gyuEujK%2Fimg.png" alt="alt text" width="360" height="whatever">

#### Proxy?

디자인 패턴의 Proxy 를 찾아볼 수 있었습니다!

: 실제 작업을 해당 객체에 위임(Delegate)하거나 동작을 변경합니다.

결국엔 Delegate == Proxy 같은 의미로 해석되어 집니다.

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FkBQls%2FbtqxWeMuMes%2FkD349NoQAC7VGQuJVSZRCk%2Fimg.png" alt="alt text" width="360" height="whatever">


## Types of proxies

#### 1. Remote proxy

원격 객체에 접근하기 위해서는 marshalling and unmarshalling 해야합니다.

이러한 과정은 Remote Proxy에서 캡슐화될 수 있습니다.

예시) JSON으로 받은 데이터를 Deserializaion 합니다.

#### 2. Virtual proxy

지연로딩으로 객체를 생성할 경우에 사용됩니다.

예시) JPA ORM 으로 쿼리의 결과를 조회할 경우에 사용됩니다.

#### 3. Protection proxy

일부 리소스에 액세스 할 수 없는 경우 해당 프록시는 해당 리소스에 액세스 할 수있는 응용 프로그램의 개체와 통신 한 다음 결과를 다시 가져옵니다.

#### 4. Smart Proxy

개체에 액세스 할 때 특정 작업을 수행하여 추가 보안 계층을 제공합니다.

실제 개체가 액세스되어 다른 개체가 변경되지 않도록 하기 전에 실제 개체가 잠겨 있는지 확인하는 예를 들 수 있습니다.

#### 여기서 잠깐 생각해보긔!

DelegateProxy 는 4가지 중 어떤 Proxy type에 속할까요??

바로 **Virtual Proxy**에 속합니다. 

그 이유는 delegate 를 미리 생성하는 것이 아니라 지연 로딩으로 delegate 가 필요할 때 생성됩니다.


## 이제 코딩으로 들어가볼까요?

예제 소개: MKLocalSearchCompleter 객체를 사용하여 자체지도 기반 검색 컨트롤에 대한 자동 완성 제안을 검색 할 수 있습니다. 

MKLocalSearchCompleter 에 대한 예제를 작성할 것이며 

queryFragment 를 전달하면 completerDidUpdateResults(_:) 으로 결과를 알 수 있습니다.

### Demo
<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2Fr5WZz%2FbtqxXITGxnc%2Fp79I3O5P2Wy0HnlN3VYqQk%2Fimg.gif" alt="alt text" width="360" height="whatever">




### Client 코드입니다.
<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2Fpp5Qi%2FbtqxX8d9k2A%2FO8SCopxLoPog3iR94LnxkK%2Fimg.png" alt="alt text" width="360" height="whatever">

### Reactive 의 Base: MKLocalSearchCompleter 정의는 이렇습니다!
<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FcSGb9C%2FbtqxWcV6seS%2FQ5gx82PhBBkYlAtZYyk420%2Fimg.png" alt="alt text" width="360" height="whatever">

### RxMKLocalSearchCompleterDelegateProxy 코드입니다.
<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FbjdS7d%2FbtqxVeAaJTZ%2FsGY107LcbuB7wat8BTSCg1%2Fimg.png" alt="alt text" width="360" height="whatever">


### 시퀀스 다이어그램
개인적인 이해를 바탕으로 직접 그렸기 때문에 정확하지 않을 수 있습니다.

![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FbdegJN%2Fbtqyd6z115d%2FgG821PUjkwYKDNCcD10us1%2Fimg.png)


### RxMKLocalSearchCompleterDelegateProxy의 `DelegateProxy` 갑자기 튀어나와서 당황하셨을 겁니다.
<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FBQkYK%2FbtqxWKrwSIo%2FkUg6pdGmk6VkUWJFecQNL0%2Fimg.png" alt="alt text" width="360" height="whatever">

### DelegateProxyType  은 무엇을 하는 것인지 알아보죠!

* ScrollView 예제로 대체됩니다.
* RxScrollViewDelegateProxy <--- RxMKLocalSearchCompleterDelegateProxy
* UIScrollViewDelegate <--- MKLocalSearchCompleterDelegate
* UIScrollView <--- MKLocalSearchCompleter

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FpIjJa%2FbtqxXKkmeDE%2Fx4sGWHqUCsSh8qXZs0quQk%2Fimg.png" alt="alt text" width="whatever" height="whatever">

### [DelegateProxyType](https://github.com/ReactiveX/RxSwift/blob/master/RxCocoa/Common/DelegateProxyType.swift) 내용에 의하면 
`DelegateProxyType` 프로토콜을 따르면 Delegate, Observable sequences 를 사용할 수 있다고 하네요.

단 View는 하나의 Delegate or DataSource 만 등록할 수 있습니다.

```
`DelegateProxyType` protocol enables using both normal delegates and Rx observable sequences with
views that can have only one delegate/datasource registered
```

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FI3FlP%2FbtqxZqSV5lX%2FrTtDY6MuCxIvSHuCAHJcl0%2Fimg.png" alt="alt text" width="whatever" height="whatever">

위 그림은 DelegateProxy는 중간 변환 역할을 나타내는 그림입니다. 

 

Proxy 의 정의에서 위임과 동작의 변형 두 가지 모두를 수행하고 있다는 것을 알 수 있습니다.

```
실제 작업을 해당 객체에 위임(Delegate)하거나 동작을 변경합니다.
 ```
