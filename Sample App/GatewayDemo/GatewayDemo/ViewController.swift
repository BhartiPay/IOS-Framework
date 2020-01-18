//
//  ViewController.swift
//  GatewayDemo
//
//  Created by iOS Dev on 17/03/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import BhartiPay

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var environmentSwitch: UISwitch!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var paymentModeSegment: UISegmentedControl!
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.makePayement()
        return true
    }
    
    @IBAction func makePayement() {
        self.view.endEditing(true)
        
        var mode: BPPaymentMode = .All

        switch paymentModeSegment.selectedSegmentIndex {
        case 0:
            mode = .All
        case 1:
            mode = .CreditCard
        case 2:
            mode = .DebitCard
        case 3:
            mode = .NetBanking
        case 4:
            mode = .Wallet
        default:
            mode = .None
        }
        
        let amount = Int(amountTextField.text ?? "200") ?? 200
        
        let environment = environmentSwitch.isOn ? BPEnvironment.Live : BPEnvironment.Test
        let merchantKey = environmentSwitch.isOn ? "6275179d6d2a4ad5" : "09e75bc6070e4f2f"
        let paymentID = environmentSwitch.isOn ? "1804071319261021" : "1810300735401001"

        do {
            let request = try BPRequest(
                environment: environment,
                merchantKey: merchantKey,
                merchantName: "BHARTIPAY Live",
                paymentID: paymentID,
                paymentMode: mode,
                currencyCode: "356",
                amount: amount,
                orderID: "\(Int(Date().timeIntervalSince1970))",
                transactionType: "SALE",
                productDesc: "BHARTIPAY Demo Transaction",
                customerName: "BHARTIPAY LIVE",
                customerEmail: "neeeeeraj.kumar@bhartipay.com",
                customerPhone: "9999999999",
                customerAddress: "Gurgaon",
                customerZip: "122016",
                screenTitle: "BhartiPayPG",
                returnURL: nil)
            
            BhartiPay.initiateTransaction(request: request, delegate: self, controller: self)
        } catch {
            print(error)
        }
    }
}



extension ViewController: BhartiPayDelegate {
    
    func transactionError(errorType: BPErrorType, message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func transactionResponse(response: BPResponse) {
        let alert = UIAlertController(title: response.status, message: response.responseMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
