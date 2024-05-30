//
//  KhaltiPayConfig.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//

import Foundation


@objc public class KhaltiPayConfig: NSObject {
    private var publicKey:String
    private var productId:String
    
    private var pIdx:String
    private var openInKhalti:bool
    
    @objc public init(publicKey:String,  productId:String,pIdx:String,openInKhalti ?= false) {
        self.publicKey = publicKey
        self.productId = productId
        self.openInKhalti = openInKhalti
        self.pIdx = pidx
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

