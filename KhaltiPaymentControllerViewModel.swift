//
//  KhaltiPaymentControllerViewModel.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/11/24.
//

import Foundation

class KhaltiPaymentControllerViewModel {
    var khalti:Khalti?
//    let khalti = KhaltiGlobal.khalti
    let service = KhaltiAPIService()
    
    init(khalti:Khalti? = nil) {
        self.khalti = khalti
    }
    
    func getPaymentDetail(onCompletion: @escaping ((PaymentDetailModel)->()), onError: @escaping ((String)->())){
        let baseUrl = getBaseUrl()

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
    
    func verifyPaymentStatus(onCompletion:@escaping((PaymentLoadModel)->()),onError: @escaping ((String)->())){
        let baseUrl = getBaseUrl()
        
        let url = baseUrl.appendUrl(url: Url.LOOKUP_SDK)
        if let pIdx = KhaltiGlobal.khaltiConfig?.pIdx {
            var params = [String:String]()
            params["pidx"] = pIdx
            service.fetchPaymentStatus(url:url,params: params, onCompletion: {(response) in
                onCompletion(response)
            }, onError: {(error) in
                onError(error)
                
            })
            
        }
        
    }
    
    private func getBaseUrl() ->Url{
        let isProd = khalti?.config.isProd() ?? false
        let baseUrl = isProd ? Url.BASE_KHALTI_URL_PROD: Url.BASE_KHALTI_URL_STAGING
        return baseUrl
    }
}
