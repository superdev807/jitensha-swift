//
//  PaymentsViewController.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/13/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PaymentsViewController: UIViewController {

    @IBOutlet weak var tableViewMain: UITableView!
    
    var viewModel = PaymentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableViewMain.tableFooterView = UIView()
        _ = viewModel.payments.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            guard let this = self else {return}
            this.tableViewMain.reloadData()
        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Payments"
    }
    
}

extension PaymentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.payments.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell
        cell.setupCell(with: viewModel.payments.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

