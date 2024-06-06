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
    private var openInKhalti:Bool = false
    private var environment:Environment?
    
    @objc public init(publicKey:String,pIdx:String,openInKhalti:bool? = false,environment:Environment) {
        self.publicKey = publicKey
        self.pIdx = productId
        self.openInKhalti= openInKhalti
        self.environment = environment
    }
    

    @objc public func getPidx() -> String {
        return self.productId
    }
    @objc public func getPublicKey() -> String {
        return self.publicKey
    }
    @objc public func getOpenInKhalti() -> Bool{
        return self.openInKhalti
    }
    @objc public func getEnvironment() -> Environment{
        return self.environment
    }

}

