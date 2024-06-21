//
//  OnMessagePayload.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/6/24.
//

import Foundation

public class OnMessagePayload {
    public var event:OnMessageEvent
    public var message:String
    public var code:Int?
    public var needsPaymentConfirmation:Bool = false
    
    init(event: OnMessageEvent, message: String, code: Int?, needsPaymentConfirmation:Bool? = false) {
        self.event = event
        self.message = message
        self.code = code
        self.needsPaymentConfirmation = needsPaymentConfirmation!
    }
    
    convenience init(event: OnMessageEvent, message: String) {
        self.init(event: event, message: message,code: nil,needsPaymentConfirmation: false)
    }
}


