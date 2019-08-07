//
//  ViewController.swift
//  RxStudy
//
//  Created by tskim on 06/08/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var subscribeOnButton: UIButton!
    @IBOutlet weak var observableSubscribeOn: UIButton!
    @IBOutlet weak var buttonSubscribeOn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeOnButton.rx.tap
            .subscribeOn(SerialDispatchQueueScheduler(internalSerialQueueName: "test"))
            .subscribe(onNext: {
                print("subscribeOnButton ThreadName: \(threadName())")
            })


        buttonSubscribeOn.rx.tap
            .concatMap { self.createObservable("concatMap") }
            .do(onNext: { _ in
                print("concatMap ThreadName: \(threadName())")
            })
            .flatMap { _ in self.createObservable("flatMap") }
            .do(onNext: { _ in
                print("flatMap ThreadName: \(threadName())")
            })
            .subscribe(onNext: { _ in
                print("subscribe ThreadName: \(threadName())")
            })
    }
    @IBAction func tapObservableSubscribeOn(_ sender: Any) {
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
    }
    func createObservable(_ with: String) -> Observable<Int> {
        return Observable.just(1).subscribeOn(SerialDispatchQueueScheduler(internalSerialQueueName: with))
    }
}

