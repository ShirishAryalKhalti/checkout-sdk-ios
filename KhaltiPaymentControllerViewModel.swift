//
//  KhaltiPaymentControllerViewModel.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/11/24.
//

import Foundation
class KhaltiPaymentControllerViewModel {
    let khalti = KhaltiGlobal.khalti
    let service = KhaltiAPI()
    
    func getPaymentDetail(onCompletion: @escaping ((PaymentDetailModel)->()), onError: @escaping ((String)->())){
        let baseUrl = isProd() ? Url.BASE_KHALTI_URL_PROD: Url.BASE_PAYMENT_URL_STAGING
        
        let url = baseUrl.appendUrl(url: Url.PAYMENT_DETAIL)
        if let pIdx = KhaltiGlobal.khaltiConfig?.pIdx {
            var params = [String:String]()
            params["pidx"] = pIdx
            service.fetchDetail(url:url,params: params, onCompletion: {(response) in
                onCompletion(response)
            }, onError: {(error) in
                onError(error)
                
            })
            
        }
        
        
    }
    
    func verifyPaymentStatus(onCompletion:@escaping((PaymentDetailModel)->()),onError: @escaping ((String)->())){
        
        
    }
    
    private func isProd() ->Bool{
        khalti?.config.isProd() ?? false
    }
}
