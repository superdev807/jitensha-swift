//
//  RLUserCell.swift
//  jitensha
//
//  Created by Benjamin Chris on 20/07/2017.
//  Copyright © 2017 crossover. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelCardNumber: UILabel!
    @IBOutlet weak var labelCardName: UILabel!
    @IBOutlet weak var labelPlaceId: UILabel!
   
    func setupCell(with payment: Payment) {
        self.labelCardName.text = payment.cardName
        self.labelCardNumber.text = "\(payment.cardNumber ?? "") \(payment.cardExpiryMonth ?? "00")/\(payment.cardExpiryYear ?? "2000") \(payment.cardCVV ?? "")"
        self.labelPlaceId.text = payment.placeId
        self.labelTime.text = ((payment.createdAt ?? "").date(format: "yyyy-MM-dd'T'HH:mm:ss.sssZ") ?? Date()).toString(format: "MM/dd/yyyy hh:mm a")
    }
}
