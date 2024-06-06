//
//  PaymentResult.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//
import Foundation

@objc public class PaymentResult: NSObject {
    private var status:String
    private var message:String
    private var returnUrl:String?
    private var amount:Double
    private var openInKhalti:Bool = false
    private var onPaymentResult:PaymentPayLoad?
    
    @objc public init(status:String, message:String,payload:String,amount:Double = 0, openInKhalti:Bool = false,returnUrl:String,onPaymentResult:PaymentPayLoad?) {
        self.status = status
        self.message = message
        self.returnUrl = returnUrl
        self.amount = amount
        self.onPaymentResult = onPaymentResult
        self.openInKhalti = openInKhalti
        
    }
}
    
    @objc public class PaymentPayLoad: NSObject {
        private var pidx:String
        private var totalAmount:Double
        private var status:String
        private var transactionId:String
        private var fee:Double
        private var refunded:Bool = true
        
        @objc public init(pidx:String, totalAmount:Double, status:String,transactionId:String,fee:Double = 0, refunded: Bool = false) {
            self.pidx = pidx
            self.totalAmount = totalAmount
            self.status = status
            self.transactionId = transactionId
            self.fee = fee
            self.refunded = refunded
        }
    }
