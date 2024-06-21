//
//  KhaltiPaymentViewDataModel.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/21/24.
//

import Foundation

class KhaltiPaymentViewDataModel{
    
    private var message:String = ""
    private var messagEvent = OnMessageEvent.Unknown
    private var errorModel:ErrorModel?
    private var statusCode = 0
    private var needsPaymentConfirmation:Bool = false
    
    private var isPayment:Bool = false
    
    init(errorModel:ErrorModel,isPayment:Bool){
        self.errorModel = errorModel
        self.isPayment  = isPayment
    }
    
    
   
    private func getMessageEvent(){
        switch self.errorModel?.errorType {
            case .ServerUnreachable:
                self.messagEvent = OnMessageEvent.NetworkFailure
                self.needsPaymentConfirmation = true
            case .Httpcall:
                self.messagEvent
            case .Generic:
                <#code#>
            case .ParseError:
                self.messagEvent = (isPayment ?? false) ? OnMessageEvent.PaymentLookUpFailure : OnMessageEvent.ReturnUrlLoadFailure

            case nil:
                OnMessageEvent.Unknown
        }
    }
    
    private func setMessageEvent(){
        
    }
    
    private func getEvent () -> OnMessageEvent{
        return (isPayment) ? OnMessageEvent.PaymentLookUpFailure : OnMessageEvent.ReturnUrlLoadFailure
    }
    
    private func returnOnMessagePayload() -> OnMessagePayload{
        
    }
    
}
