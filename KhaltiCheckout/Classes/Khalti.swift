//
//  Khalti.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//

import Foundation
public typealias OnPaymentResult = (PaymentResult,Khalti) -> ()
public typealias OnMessageResult = (OnMessage,Khalti) -> ()
public typealias OnReturn = (Khalti) -> ()


public class Khalti{
    private var config:KhaltiPayConfig
    private var onPaymentResult: OnPaymentResult
    private var onMessage: OnMessageResult
    private var onReturn:OnReturn
    
     public init(config: KhaltiPayConfig,onPaymentResult: @escaping OnPaymentResult,onMessage:@escaping OnMessageResult,onReturn:@escaping OnReturn) {
        self.config = config
        self.onPaymentResult = onPaymentResult
        self.onMessage = onMessage
        self.onReturn = onReturn
    }
    
    
}
