//
//  KhaltiPaymentControllerViewModel.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/11/24.
//

import Foundation
class KhaltiPaymentControllerViewModel {
    
    let service = KhaltiAPI()
    
    func getPaymentDetail(onCompletion: @escaping ((PaymentDetailModel)->()), onError: @escaping ((String)->())){
        if let pIdx = KhaltiGlobal.khaltiConfig?.pIdx {
            var params = [String:String]()
            params["pidx"] = pIdx
            service.fetchDetail(params: params, onCompletion: {(response) in
                onCompletion(response)
            }, onError: {(error) in
                onError(error)
                
            })
            
        }
        
        
    }
}
