//
//  LoginViewController.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/12/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var textfieldEmailAddress: UITextField!
    @IBOutlet weak var viewIndicatorEmailAddress: UIView!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var viewIndicatorPassword: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var activityIndicatorLogin: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorSignup: UIActivityIndicatorView!
    
    var viewModel: UserAuthViewModel = UserAuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.initializeGUI()
        
        self.observe()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    func initializeGUI() {
        
        self.viewIndicatorEmailAddress.backgroundColor = AppConfig.configAppGrayColor
        self.viewIndicatorPassword.backgroundColor = AppConfig.configAppGrayColor
        
        self.btnLogin.isEnabled = false
        self.btnSignup.isEnabled = false
        self.btnLogin.alpha = 0.6
        self.btnSignup.alpha = 0.6
        
        self.btnLogin.layer.cornerRadius = 10
        self.btnSignup.layer.cornerRadius = 10
        
        self.activityIndicatorLogin.stopAnimating()
        self.activityIndicatorSignup.stopAnimating()
        
    }
    
    // add observer into view model
    
    func observe() {
        _ = viewModel.user.asObservable().skip(1).observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (user) in
            
            guard let this = self else {return}
            
            this.view.isUserInteractionEnabled = true
            this.activityIndicatorLogin.stopAnimating()
            this.activityIndicatorSignup.stopAnimating()
            
            if (user.code != nil) {
                if "UserNotFound" == user.message {
                    AppUtils.showSimpleAlertMessage(for: this, title: nil, message: "Invalid credentials. Please try again.")
                } else if "EmailAlreadyTaken" == user.message {
                    AppUtils.showSimpleAlertMessage(for: this, title: nil, message: "Email already taken.")
                } else {
                    AppUtils.showSimpleAlertMessage(for: this, title: nil, message: user.message ?? "Authentication failed.  Please try again later.")
                }
            } else if user.token != nil {
                AppManager.shared.token = user.token
                AppManager.shared.saveTokenToPersistStore()
                this.openHome()
            } else {
                AppUtils.showSimpleAlertMessage(for: this, title: nil, message: user.message ?? "Authentication failed.  Please try again later.")
            }
            
        }, onError: { [weak self] (err) in
                
                guard let this = self else {return}
            
                this.view.isUserInteractionEnabled = true
                this.activityIndicatorLogin.stopAnimating()
                this.activityIndicatorSignup.stopAnimating()
                AppUtils.showSimpleAlertMessage(for: this, title: nil, message: err.localizedDescription)
            
        })
    }

    // GUI IBActions
    
    // Process textfield focusing for indicators
    @IBAction func onEditingDidBegin(_ sender: UITextField) {
        if sender == self.textfieldEmailAddress {
            self.viewIndicatorEmailAddress.backgroundColor = AppConfig.configAppPrimaryColorBlue
        } else if sender == self.textfieldPassword {
            self.viewIndicatorPassword.backgroundColor = AppConfig.configAppPrimaryColorBlue
        }
    }
    
    @IBAction func onEditingDidEnd(_ sender: UITextField) {
        if sender == self.textfieldEmailAddress {
            self.viewIndicatorEmailAddress.backgroundColor = AppConfig.configAppGrayColor
        } else if sender == self.textfieldPassword {
            self.viewIndicatorPassword.backgroundColor = AppConfig.configAppGrayColor
        }
    }
    
    // Process editing changed for action buttons
    @IBAction func onEditingChanged(_ sender: Any) {
        self.updateActionEnabledStatus()
    }
    
    func updateActionEnabledStatus() {
        if self.textfieldEmailAddress.text != "" && self.textfieldEmailAddress.text!.isValidEmail() && self.textfieldPassword.text != "" {
            self.btnLogin.isEnabled = true
            self.btnLogin.alpha = 1
            self.btnSignup.isEnabled = true
            self.btnSignup.alpha = 1
        } else {
            self.btnLogin.isEnabled = false
            self.btnLogin.alpha = 0.6
            self.btnSignup.isEnabled = false
            self.btnSignup.alpha = 0.6
        }
    }
    
    @IBAction func onLogin(_ sender: Any) {
        self.view.endEditing(true)
        self.activityIndicatorLogin.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        viewModel.login(email: textfieldEmailAddress.text ?? "", password: textfieldPassword.text ?? "")
    }
    
    @IBAction func onSignup(_ sender: Any) {
        self.view.endEditing(true)
        self.activityIndicatorSignup.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        viewModel.register(email: textfieldEmailAddress.text ?? "", password: textfieldPassword.text ?? "")
    }
    
    func openHome() {
        self.performSegue(withIdentifier: "sid_home", sender: nil)
    }
    
}
