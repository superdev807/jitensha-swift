//
//  PlacesViewModel.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/13/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import UIKit
import RxSwift

class PlacesViewModel {
    
    var disposable: DisposeBag?
    
    var places = Variable([Place]())
    
    init() {
        disposable = DisposeBag()
    }
    
    func loadPlaces() {
        APIManager.getList(.placesList).subscribe(onNext: { [weak self] (places: [Place]) in
            self?.places.value = places
        }).disposed(by: disposable!)
    }
    
    deinit {
        disposable = nil
    }
}
