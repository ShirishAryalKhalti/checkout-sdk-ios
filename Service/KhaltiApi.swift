//
//  KhaltiApi.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/6/24.
//

import Foundation

class KhaltiAPI {
    
    //    static let shared = KhaltiAPI()
    //    static let logMessage:Bool = Khalti.shared.debugLog
    
    private func createGetRequest(for url:URL,body:[String:String]) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpBody = createHttpBody(body: body)
        
        request.setValue(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, forHTTPHeaderField: "checkout-version")
        request.setValue("iOS", forHTTPHeaderField: "checkout-source")
        request.setValue(UIDevice.current.model, forHTTPHeaderField: "checkout-device-model")
        request.setValue(UIDevice.current.identifierForVendor?.uuidString ?? "", forHTTPHeaderField: "checkout-device-id")
        request.setValue(UIDevice.current.systemVersion, forHTTPHeaderField: "checkout-ios-version")
        return request
    }
    private func createHttpBody(body:[String:String]) ->Data?{
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error converting parameters to JSON")
            return nil
        }
        return jsonData
    }
    
    
    private func createRequest(for url:URL,body:[String:String]) -> URLRequest {
        
        var request = URLRequest(url: url)
        
        request.httpBody = createHttpBody(body: body)
        request.httpMethod = "POST"
        request.setValue(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, forHTTPHeaderField: "checkout-version")
        request.setValue("iOS", forHTTPHeaderField: "checkout-source")
        request.setValue(UIDevice.current.model, forHTTPHeaderField: "checkout-device-model")
        request.setValue(UIDevice.current.identifierForVendor?.uuidString ?? "", forHTTPHeaderField: "checkout-device-id")
        request.setValue(UIDevice.current.systemVersion, forHTTPHeaderField: "checkout-ios-version")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func fetchDetail(params:[String:String],onCompletion: @escaping ((PaymentDetailModel)->()), onError: @escaping ((String)->())) {
        let config = KhaltiGlobal.khaltiConfig
        let urlEnv = (config?.isProd() ?? false) ? Url.BASE_KHALTI_URL_PROD: Url.BASE_KHALTI_URL_STAGING
        let url = urlEnv.appendBaseUrl(url:Url.PAYMENT_DETAIL.rawValue)
        
        
        guard let url = URL(string: url) else {
            onError("Error on parsing Url")
            return
        }
        
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = self.createRequest(for: url,body: params)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            print("===========================================================")
            print("Status: \(request), Response for: \(url)")
            print("===========================================================")
            
            
            
            guard let data = data else {
                //                onError(NetworkError.noData.rawValue)
                return
            }
            
            print(response)
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                //                onError(NetworkError.noResponse.rawValue)
                
                return
            }
            
            print("Status: \(response.statusCode), Response for: \(url)")
            print("===========================================================")
            print("\(response)")
            print("===========================================================")
            
            
            do {
                let user = try JSONDecoder().decode(PaymentDetailModel.self, from: data)
                print(user)
                onCompletion(user)
            } catch {
                onError(error.localizedDescription)
                //                onError(NetworkError.parseError.rawValue)
            }
        }
        
        task.resume()
    }
    
    //    func epaymentLookUp(onCompletion: @escaping (([String:Any])->()), onError: @escaping ((String)->())) {
    //
    //        let urlString:String = KhaltiAPIUrl.cardTerms.rawValue
    //        guard let url = URL(string: urlString) else {
    //            onError(ErrorMessage.invalidUrl.rawValue)
    //            return
    //        }
    //
    //        let configuration = URLSessionConfiguration.ephemeral
    //        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    //        let request = self.createRequest(for: url)
    //        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
    //
    //            guard let data = data else {
    //                onError((error?.localizedDescription)!)
    //                return
    //            }
    //
    //            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
    ////                onError(ErrorMessage.parse.rawValue)
    //                return
    //            }
    //            guard let responsee = response as? HTTPURLResponse else {
    ////                onError(ErrorMessage.noresponse.rawValue)
    //                return
    //            }
    //
    ////            if KhaltiAPI.logMessage {
    ////                print("Status: \(responsee.statusCode), Response for: \(url)")
    ////                print("===========================================================")
    ////                print("\(json)")
    ////                print("===========================================================")
    ////            }
    //
    //            if let value = json as? [String:Any] {
    //                onCompletion(value)
    //            } else {
    //                onError(error?.localizedDescription ?? ErrorMessage.tryAgain.rawValue)
    //            }
    //        }
    //        task.resume()
    //    }
    
}
