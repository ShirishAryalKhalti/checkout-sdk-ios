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
        service.fetchDetail { model in
            
        } onError: { msg in
            
        }

    }
}
