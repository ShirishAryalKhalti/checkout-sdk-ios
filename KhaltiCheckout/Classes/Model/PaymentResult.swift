//
//  PaymentResult.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//
import Foundation

 public class PaymentResult: NSObject {
    private var status:String?
    private var payload:PaymentLoadModel?
     private var khalti:Khalti?
    
     init(status:String, message:String,payload:PaymentLoadModel,khalti:Khalti) {
        self.status = status
        self.payload = payload
         self.khalti = khalti
        
    }
}
