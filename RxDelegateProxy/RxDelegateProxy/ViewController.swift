//
//  ViewController.swift
//  RxDelegateProxy
//
//  Created by tskim on 01/09/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var textField: UITextField!
    let searchCompleter = MKLocalSearchCompleter()
    
    var items : [String] = []
    
    @IBOutlet weak var autoCompleteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.rx.text
            .orEmpty
            .bind(to: searchCompleter.rx.queryFragment)
            .disposed(by: disposeBag)
        
        searchCompleter.rx.didUpdateResults
            .subscribe(onNext: { [weak self] completer in
                guard let self = self else { return }
                self.items = completer.results.map { $0.title }
                self.autoCompleteTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        searchCompleter.rx.didUpdateResults
            .subscribe(onNext: { [weak self] completer in
                guard let self = self else { return }
                self.items = completer.results.map { $0.title }
                self.autoCompleteTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        autoCompleteTableView.register(AutoCompleteCell.self, forCellReuseIdentifier: AutoCompleteCell.reusableKey)
        autoCompleteTableView.rx.setDataSource(self).disposed(by: disposeBag)
        autoCompleteTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension ViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutoCompleteCell.reusableKey) as? AutoCompleteCell else { return UITableViewCell() }
        cell.title.text = self.items[indexPath.row]
        return cell
    }
}
