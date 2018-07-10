//
//  UserAuthViewModel.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/13/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import Foundation
import RxSwift

class UserAuthViewModel {
    
    var disposable: DisposeBag?
    
    var user = Variable(User())
    
    init() {
        disposable = DisposeBag()
    }
    
    func login(email:String, password: String) {
        
        let user = User()
        user.email = email
        user.password = password
        
        _ = APIManager.postObject(.login(user: user)).subscribe(onNext: { [weak self] (user: User) in
            guard let this = self else {return}
            this.user.value = user
        }).disposed(by: disposable!)
        
    }
    
    func register(email:String, password: String) {
        
        let user = User()
        user.email = email
        user.password = password
        
        _ = APIManager.postObject(.register(user: user)).subscribe(onNext: { [weak self] (user: User) in
            guard let this = self else {return}
            this.user.value = user
        }).disposed(by: disposable!)
        
    }
    
    deinit {
        disposable = nil
    }
}
