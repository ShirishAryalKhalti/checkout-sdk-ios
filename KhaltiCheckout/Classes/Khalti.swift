//
//  Khalti.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//

import Foundation
typealias OnPaymentResult = ((PaymentResult,Khalti) -> () )
typealias OnMessage = ((OnMessage,Khalti) -> () )
typealias OnReturn = (Khalti) -> () )


class Khalti{
    private var config:KhaltiPayConfig
    private onPaymentResult: OnPaymentResult
    private onMessage: OnMessage
    private onReturn:OnReturn
    
    init(config: KhaltiPayConfig,onPaymentResult:OnPaymentResult,onMessage:OnMessage,onReturn:OnReturn) {
        self.config = config
        self.onPaymentResult=OnPaymentResult
        self.onMessage = OnMessage
        self.onReturn = OnReturn
    }
    
    
}
