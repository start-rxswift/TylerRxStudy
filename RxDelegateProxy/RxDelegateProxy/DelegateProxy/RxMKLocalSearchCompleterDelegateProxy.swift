//
//  RxMKLocalSearchCompleterDelegateProxy.swift
//  RxDelegateProxy
//
//  Created by tskim on 02/09/2019.
//  Copyright © 2019 hucet. All rights reserved.
//
import MapKit
import RxSwift
import RxCocoa

extension MKLocalSearchCompleter: HasDelegate {
    public typealias Delegate = MKLocalSearchCompleterDelegate
}

class RxMKLocalSearchCompleterDelegateProxy:
    DelegateProxy<MKLocalSearchCompleter, MKLocalSearchCompleterDelegate>,
    DelegateProxyType,
MKLocalSearchCompleterDelegate
{
    
    public weak private(set) var localSearchCompleter: MKLocalSearchCompleter?
    
    public init(localSearchCompleter: ParentObject) {
        self.localSearchCompleter = localSearchCompleter
        super.init(parentObject: localSearchCompleter,
                   delegateProxy: RxMKLocalSearchCompleterDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxMKLocalSearchCompleterDelegateProxy(localSearchCompleter: $0) }
    }
}
