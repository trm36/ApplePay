//
//  Product.swift
//  ApplePay
//
//  Created by Taylor Mott on 03-May-17.
//  Copyright © 2017 Mott Applications. All rights reserved.
//

import Foundation
import PassKit

struct Product {
    
    var name: String
    var price: Float
    
    init(name: String, price: Float) {
        self.name = name
        self.price = price
    }
    
    var pkPaymentSummary: PKPaymentSummaryItem {
        return PKPaymentSummaryItem(label: name, amount: NSDecimalNumber(value: price))
    }
    
}
