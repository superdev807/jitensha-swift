//
//  NewPaymentViewController.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/13/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import UIKit
import Stripe
import RxSwift
import RxCocoa

class NewPaymentViewController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelRentTitle: UILabel!
    @IBOutlet weak var viewCardContainer: UIView!
    @IBOutlet weak var buttonRent: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    var paymentTextField: STPPaymentCardTextField!
    
    var viewModel: NewPaymentViewModel = NewPaymentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeGUI()
        
        self.observe()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.paymentTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.paymentTextField.frame = self.viewCardContainer.bounds
    }
    
    func initializeGUI() {
        self.viewContainer.layer.cornerRadius = 20
        self.buttonRent.layer.cornerRadius = 10
        self.buttonCancel.layer.cornerRadius = 10
        
        self.paymentTextField = STPPaymentCardTextField()
        self.paymentTextField.delegate = self
        self.paymentTextField.cursorColor = AppConfig.configAppPrimaryColorBlue
        self.viewCardContainer.addSubview(self.paymentTextField)
        
        self.buttonRent.isEnabled = false
        self.buttonRent.alpha = 0.7
        
        self.labelRentTitle.text = "Rent \(self.viewModel.place.value.name ?? "")"
    }
    
    func observe() {
        _ = self.viewModel.responseResult.asObservable().skip(1).observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (requestResult) in
            guard let this = self else {return}
            this.view.isUserInteractionEnabled = true
            if "PaymentSuccess" == requestResult.message {
                AppUtils.showSimpleAlertMessage(for: this, title: nil, message: "Successfully done.", handler: { _ in
                    this.dismiss(animated: true, completion: nil)
                })
            } else {
                var errorMessage = ""
                if "PlaceNotFound" == requestResult.message {
                    errorMessage = "Place not found."
                } else if "InvalidCreditCard" == requestResult.message {
                    errorMessage = "Invalid credit card."
                } else if "Unauthorized" == requestResult.message {
                    errorMessage = "Invalid or missing required authentication token."
                } else if "InvalidJson" == requestResult.message {
                    errorMessage = "Invalid json format."
                } else {
                    errorMessage = "Unexpected error."
                }
                
                AppUtils.showSimpleAlertMessage(for: this, title: nil, message: errorMessage)
            }
            }, onError: { [weak self] (err) in
                
                guard let this = self else {return}
                
                this.view.isUserInteractionEnabled = true
                AppUtils.showSimpleAlertMessage(for: this, title: nil, message: err.localizedDescription)
                
        })

    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onRent(_ sender: Any) {
        let cardParams = self.paymentTextField.cardParams
        self.view.endEditing(true)
        self.view.isUserInteractionEnabled = false
        self.viewModel.createPayment(number: cardParams.number ?? "", name: cardParams.name ?? "Test", cvv: cardParams.cvc ?? "", expiryMonth: "\(cardParams.expMonth)", expiryYear: "20\(cardParams.expYear)")
    }
}

extension NewPaymentViewController: STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        self.buttonRent.isEnabled = textField.isValid
        if self.buttonRent.isEnabled {
            self.buttonRent.alpha = 1
        } else {
            self.buttonRent.alpha = 0.7
        }
    }
}
