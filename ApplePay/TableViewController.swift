//
//  ViewController.swift
//  ApplePay
//
//  Created by Taylor Mott on 03-May-17.
//  Copyright © 2017 Mott Applications. All rights reserved.
//

import UIKit
import PassKit

class TableViewController: UITableViewController, PKPaymentAuthorizationViewControllerDelegate {
    
    var products = [Product(name: "After-Hours Mentor Time - 30 min", price: 30.00)]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productCell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
     
        let product = products[indexPath.row]
        
        productCell.textLabel?.text = product.name
        productCell.detailTextLabel?.text = String(format: "$ %.2f", product.price)
        
        return productCell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let paymentNetworks: [PKPaymentNetwork] = [.amex, .masterCard, .visa, .discover]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            //Pay is available!
            
            let request = PKPaymentRequest()
            request.supportedNetworks = paymentNetworks
            request.countryCode = "US"  //two-letter ISO 3166 country code
            request.currencyCode = "USD" //three-letter ISO 4217 currency code
            request.merchantCapabilities = .capability3DS
            request.merchantIdentifier = "merchant.com.mottapplications"
            
            let pkProduct = products[indexPath.row].pkPaymentSummary
            let discount = PKPaymentSummaryItem(label: "New Client Discount", amount: NSDecimalNumber(string: "-5.00"))
            
            let totalAmount = pkProduct.amount.adding(discount.amount)
            let total = PKPaymentSummaryItem(label: "Mentor", amount: totalAmount)
            
            request.paymentSummaryItems = [pkProduct, discount, total]
            
            let paymentViewController = PKPaymentAuthorizationViewController(paymentRequest: request)
            paymentViewController.delegate = self
            present(paymentViewController, animated: true)
        } else {
            //Show your own credit card form
        }
    }
    
    // MARK: - PKPaymentAuthorizationViewControllerDelegate
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        // Use your payment processor's SDK to finish charging your customer.
        // When this is done, call:
        completion(.success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }


}

