//
//  ViewController.swift
//  RxBinder
//
//  Created by tskim on 01/09/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var customAttr: UILabel!
    @IBOutlet weak var controlEventButton: UIButton!
    
    private let viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlEventButton.rx.tap
            .bind(to: viewModel.controlTap)
            .disposed(by: disposeBag)
        
        viewModel
            .binderText
            .bind(to: customAttr.rx.text)
            .disposed(by: disposeBag)

    }
}

