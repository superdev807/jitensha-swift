//
//  PaymentViewModel.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/13/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import UIKit
import RxSwift

class PaymentViewModel {
    
    var disposable: DisposeBag?
    
    var payments = Variable([Payment]())
    
    init() {
        disposable = DisposeBag()
        loadPayments()
    }
    
    func loadPayments() {
        APIManager.getList(.payments).subscribe(onNext: { [weak self] (payments: [Payment]) in
            guard let this = self else {return}
            this.payments.value = payments
        }).disposed(by: disposable!)
    }
    
    deinit {
        disposable = nil
    }
}
