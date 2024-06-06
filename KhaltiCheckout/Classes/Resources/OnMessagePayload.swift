//
//  OnMessagePayload.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/6/24.
//

import Foundation

class OnMessagePayload {
    var event:OnMessageEvent
    var message:String
    var code:Int
    var needsPaymentConfirmation:Bool = false
    
    init(event: OnMessageEvent, message: String, code: Int, needsPaymentConfirmation: Bool) {
        self.event = event
        self.message = message
        self.code = code
        self.needsPaymentConfirmation = needsPaymentConfirmation
    }
}
