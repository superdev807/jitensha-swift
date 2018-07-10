//
//  NewPaymentViewModel.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/13/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import Foundation
import RxSwift

class NewPaymentViewModel {
    
    var disposable: DisposeBag?
    
    var place = Variable(Place())
    
    var responseResult = Variable(Model())
    
    init() {
        disposable = DisposeBag()
    }
    
    func createPayment(number: String, name: String, cvv: String, expiryMonth: String, expiryYear: String) {
        let payment = PaymentRequest(placeId: place.value.id, number: number, name: name, cvv: cvv, expiryMonth: expiryMonth, expiryYear: expiryYear)
        APIManager.postObject(.createPayment(payment: payment)).subscribe(onNext: { [weak self] (res: Model) in
            guard let this = self else {return}
            this.responseResult.value = res
        }).disposed(by: disposable!)
    }
    
    deinit {
        disposable = nil
    }
}
