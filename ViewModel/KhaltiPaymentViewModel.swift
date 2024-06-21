//
//  KhaltiPaymentControllerViewModel.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/11/24.
//

import Foundation

class KhaltiPaymentControllerViewModel {
    var khalti:Khalti?
    
    let service = KhaltiAPIService()
    let monitor = NetworkMonitor.shared
    
    
    init(khalti:Khalti? = nil) {
        self.khalti = khalti
    }
    
    func getPaymentDetail(onCompletion: @escaping ((PaymentDetailModel)->()), onError: @escaping ((String)->())){
        
        let baseUrl = getBaseUrl()
        if isNetworkReachable(){
            let url = baseUrl.appendUrl(url: Url.PAYMENT_DETAIL)
            if let pIdx = khalti?.config.pIdx {
                var params = [String:String]()
                params["pidx"] = pIdx
                service.fetchDetail(url:url,params: params, onCompletion: {(response) in
                    onCompletion(response)
                    
                }, onError: {[weak self](error) in
                    self?.createViewModelData(error: error, isPayment: false)
//                    onError(error)
                })
            }
            
        }else{
            handleNetworkConnectivityFailure(onMessagePayload: OnMessagePayload(event: OnMessageEvent.NetworkFailure, message: "Network Error"))
        }
        
    }
    
    func verifyPaymentStatus(onCompletion:@escaping((PaymentLoadModel)->()),onError: @escaping (()->())){
        let baseUrl = getBaseUrl()
        if isNetworkReachable(){
            let url = baseUrl.appendUrl(url: Url.LOOKUP_SDK)
            if let pIdx = khalti?.config.pIdx {
                var params = [String:String]()
                params["pidx"] = pIdx
                service.fetchPaymentStatus(url:url,params: params, onCompletion: {(response) in
                    onCompletion(response)
                }, onError: {[weak self](error) in
                    self?.createViewModelData(error: error, isPayment: true)
//                    onError(error.errorTyp)
                    
                })
                
            }
        }else{
            handleNetworkConnectivityFailure(onMessagePayload: OnMessagePayload(event: OnMessageEvent.NetworkFailure, message: "Network Error"))
        }
        
        
    }
    
    private func createViewModelData(error:ErrorModel,isPayment:Bool){
        let viewModelData = KhaltiPaymentViewDataModel(errorModel:error,isPayment:isPayment )
        
    }
    
    private func handleNetworkConnectivityFailure(onMessagePayload:OnMessagePayload){
        khalti?.onMessage(onMessagePayload,khalti)
    }
    
    private func isNetworkReachable() -> Bool{
        let isConnected = monitor.isConnected
        return isConnected
    }
    
    
    private func getBaseUrl() ->Url{
        let isProd = khalti?.config.isProd() ?? false
        let baseUrl = isProd ? Url.BASE_KHALTI_URL_PROD: Url.BASE_KHALTI_URL_STAGING
        return baseUrl
    }
}
