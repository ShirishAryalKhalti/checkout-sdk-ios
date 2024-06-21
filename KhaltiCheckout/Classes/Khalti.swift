//
//  Khalti.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//

import Foundation
public typealias OnPaymentResult = ((PaymentResult,Khalti?) -> ())
public typealias OnMessageResult = (OnMessagePayload,Khalti?) -> ()
public typealias OnReturn = (Khalti?) -> ()


public class Khalti{
    public var config:KhaltiPayConfig
    public var onPaymentResult: OnPaymentResult
    public var onMessage: OnMessageResult
    public var onReturn:OnReturn
    
    
    public init(config: KhaltiPayConfig,onPaymentResult: @escaping OnPaymentResult,onMessage:@escaping OnMessageResult,onReturn:@escaping OnReturn) {
        self.config = config
        self.onPaymentResult = onPaymentResult
        self.onMessage = onMessage
        self.onReturn = onReturn
////        KhaltiGlobal.setKhalti(khalti: self)
////        KhaltiGlobal.setKhaltiPayconfig(config: self.config)
    }
    
    
    func copyWith( config: KhaltiPayConfig? = nil, onPaymentResult: OnPaymentResult? = nil, onMessage: OnMessageResult? = nil,onReturn:OnReturn? = nil) -> Khalti{
        return Khalti(
            config: config ?? self.config,
            onPaymentResult: onPaymentResult ?? self.onPaymentResult,
            onMessage: onMessage ?? self.onMessage,
            onReturn: onReturn ?? self.onReturn
        )
    }
    
    func getConfig() -> KhaltiPayConfig{
        return self.config
    }
    
    
    
    
    @objc public func open(viewController:UIViewController){
        let vc = KhaltiPaymentViewController()
        vc.khalti = self
        vc.modalPresentationStyle = .fullScreen
        
        viewController.present(vc, animated:false)
        
        
    }
    
    @objc public func close(){
        NotificationCenter.default.post(name: .notificationAction, object: nil)
        
    }
   
    @objc public func verify(){
        NotificationCenter.default.post(name: .notificationType, object: nil)
    }
    
    
}
