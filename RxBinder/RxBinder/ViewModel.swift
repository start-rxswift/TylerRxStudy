//
//  ViewModel.swift
//  Pods-RxBinder
//
//  Created by tskim on 01/09/2019.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    let binderText = PublishRelay<String>()
    let controlTap = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    init() {
        controlTap
            .subscribe(onNext: { [weak binderText] _ in
                binderText?.accept("custom")
            })
            .disposed(by: disposeBag)
    }
}
