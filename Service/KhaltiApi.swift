//
//  KhaltiApi.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/6/24.
//

import Foundation
import Network

protocol KhaltiApiServiceProtocol {
    func handleRequest<T: Codable>(request: URLRequest, onSuccess: @escaping (T) -> (), onError: @escaping (String) -> ())
}

class KhaltiAPIService {

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
    
    func fetchDetail(url:String,params:[String:String],onCompletion: @escaping ((PaymentDetailModel)->()), onError: @escaping ((String)->())) {
        
        guard let url = URL(string:url) else {
            onError("Error on parsing Url")
            return
        }
        
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = self.createRequest(for: url,body: params)
        print("===========================================================")
        print("Request Url:")
        print (request.url)
        print(request.allHTTPHeaderFields)
        print("===========================================================")
        
        if let bodyData = request.httpBody {
            if let bodyString = String(data: bodyData, encoding: .utf8) {
                
                print("===========================================================")
                print("Request httpBody:")
                print(bodyString)
                
                print("===========================================================")
            } else {
                print("Request httpBody is not a valid UTF-8 string.")
            }
        } else {
            print("Request does not contain a httpBody.")
        }
        self.handleRequest(request: request, onSuccess: {(model:PaymentDetailModel)in
            onCompletion(model)
        }, onError: {(error) in
            onError(error)
        })
        
    }
    
    
    func fetchPaymentStatus(url:String,params:[String:String],onCompletion: @escaping ((PaymentLoadModel)->()), onError: @escaping ((String)->())) {
        
        guard let url = URL(string: url) else {
            onError("Error on parsing Url")
            return
        }
        
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = self.createRequest(for: url,body: params)
        print("===========================================================")
        print("Request Url:")
        print (request.url)
        print(request.allHTTPHeaderFields)

        print("===========================================================")
        if let bodyData = request.httpBody {
            if let bodyString = String(data: bodyData, encoding: .utf8) {
            
                print("===========================================================")
                print("Request httpBody:")
                print(bodyString)
                print("===========================================================")
            } else {
                print("Request httpBody is not a valid UTF-8 string.")
            }
        } else {
            print("Request does not contain a httpBody.")
        }
        self.handleRequest(request: request, onSuccess: {(model:PaymentLoadModel)in
            onCompletion(model)
        }, onError: {(error) in
            onError(error)
        })
        
    }
    
}

extension KhaltiAPIService:KhaltiApiServiceProtocol{
    
    func handleRequest<T:Codable>(request: URLRequest, onSuccess: @escaping (T) -> (), onError: @escaping (String) -> ()) {

    
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                onError("Request failed with error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                onError("No data received")
                return
            }
            print("===========================================================")
            print("Received JSON data:", String(data: data, encoding: .utf8) ?? "Invalid UTF-8 data")
            print("===========================================================")
            
            
            do {
                let decoder = JSONDecoder()
                let decodedObject:T = try decoder.decode(T.self, from: data)
                onSuccess(decodedObject)
            } catch let decodingError {
                print("===========================================================")
                print(decodingError)
                print("===========================================================")
                onError("Failed to decode response")
            }
        }
        task.resume()
    }
    
    
}
