//
//  ViewController.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/12/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.perform(#selector(startApp), with: nil, afterDelay: 0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    @objc func startApp() {
        if AppManager.shared.tokenSavedInPersistStore() {
            AppManager.shared.fetchTokenFromPersistStore()
            self.performSegue(withIdentifier: "sid_home", sender: nil)
        } else {
            self.performSegue(withIdentifier: "sid_login", sender: nil)
        }
    }

}

