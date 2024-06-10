//
//  KhaltiGlobal.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/10/24.
//

import Foundation

class KhaltiGlobal {
    
    static var shared = KhaltiGlobal()
    static var khaltiConfig:KhaltiPayConfig?
    
    static func setKhaltiPayconfig(config:KhaltiPayConfig){
        self.khaltiConfig = config
    }
    
    static func getKhaltiPayconfig() -> KhaltiPayConfig?
    {
        return self.khaltiConfig;
    }
    
}
