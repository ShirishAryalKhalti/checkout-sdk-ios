//
//  KhaltiPayConfig.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//

import Foundation


@objc public class KhaltiPayConfig: NSObject {
    private var publicKey:String
    private var pIdx:String
    private var productName:String
    private var returnUrl:String?
    private var amount:Int
    private var openInKhalti:Bool = false
    private var onPaymentResult:PaymentResult?
    
    @objc public init(publicKey:String,  amount:Int, productId:String,productName:String, productUrl:String? = nil,onPaymentResult:PaymentResult) {
        self.publicKey = publicKey
        self.pIdx = productId
        self.productName = productName
        self.returnUrl = productUrl
        self.amount = amount
        self.onPaymentResult = onPaymentResult
    }
    

    @objc public func getPidx() -> String {
        return self.productId
    }
    @objc public func getPublicKey() -> String {
        return self.publicKey
    }
    @objc public func getOpenInKhalti() -> String {
        return self.openInKhalti
    }
    @objc public func productId() -> String {
        return self.productId
    }

}

