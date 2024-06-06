//
//  KhaltiPayConfig.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//

import Foundation


public class KhaltiPayConfig: NSObject {
    private var publicKey:String
    private var pIdx:String
    private var openInKhalti:Bool? = false
    private var environment:Environment = Environment.TEST
    
      public init(publicKey:String,pIdx:String,openInKhalti:Bool? = false,environment:Environment) {
        self.publicKey = publicKey
        self.pIdx = pIdx
        self.openInKhalti = openInKhalti
        self.environment = environment
    }
    

      func getPidx() -> String {
        return self.pIdx
    }
      func getPublicKey() -> String {
        return self.publicKey
    }
    func getOpenInKhalti() -> Bool{
        return self.openInKhalti!
    }
      func getEnvironment() -> Environment{
        return self.environment
    }

}

