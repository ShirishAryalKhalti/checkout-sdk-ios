
//
//  KhaltiWebViewController.swift
//  Khalti
//
//  Created by Mac on 2/20/24.
//

import UIKit
import WebKit

class KhaltiPaymentViewController: UIViewController,WKNavigationDelegate, WKUIDelegate {
    var wkWebView: WKWebView = WKWebView()
    var request:URLRequest?
    var config:KhaltiPayConfig?

    override func viewDidLoad() {
        super.viewDidLoad()
//        createPaymentWebView()
        wkWebView.backgroundColor = UIColor.lightGray
        wkWebView.frame = view.bounds
        wkWebView.center = view.center
        wkWebView.isOpaque = false
        
        // Initialize WKWebView with a configuration
          let configuration = WKWebViewConfiguration()
          wkWebView = WKWebView(frame: .zero, configuration: configuration)
          
          
          wkWebView.translatesAutoresizingMaskIntoConstraints = false
          view.addSubview(wkWebView)
        wkWebView.navigationDelegate = self
        let config = KhaltiGlobal.getKhaltiPayconfig()


          
          NSLayoutConstraint.activate([
              wkWebView.topAnchor.constraint(equalTo: view.topAnchor),
              wkWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
              wkWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              wkWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
          ])
        
        if let url = getPaymentUrl(){
            request = URLRequest(url: url)
            loadRequest()

        }
                // Do any additional setup after loading the view.
    }
    
    func getPaymentUrl() -> URL?{
        let urlEnv = (config?.isProd() ?? false) ?  Url.BASE_PAYMENT_URL_PROD : Url.BASE_PAYMENT_URL_STAGING
        
        let url = URL(string:urlEnv.rawValue)?.appendQueryParams([URLQueryItem(name: "pIdx", value: config?.pIdx ?? "")])
        print(url)
        return url
    }
    
    func loadRequest() {
        // To clear Cache of WkWebView
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: {
                if let myRequest = self.request {
                    self.wkWebView.load(myRequest)
                    self.wkWebView.navigationDelegate = self
                    self.wkWebView.uiDelegate = self
                }
            })
        }
    }
    
    func webView(_ webView: WKWebView, didReceive response: URLResponse, for navigation: WKNavigation!) {
        print("1")
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse)
            if httpResponse.statusCode == 200 {
                print("Status code is 200: OK")
                // Handle the success case
            } else {
                print("Status code is not 200: \(httpResponse.statusCode)")
                // Handle the failure case
            }
        }
    }
    

    
    func webView(_ webView: WKWebView,didFinish navigation: WKNavigation!) {
        print("3")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("4")
        if let httpResponse = navigationResponse.response as? HTTPURLResponse {
            print("HTTP response received with status code: \(httpResponse.statusCode)")
        }
        decisionHandler(.allow)
    }
    
    
    // Intercept and examine the request URL
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            print("Intercepted request URL: \(url)")
            
            // You can perform any custom logic here, e.g., checking the URL
            if url.host == "www.example.com" {
                print("Allowing navigation to \(url)")
                decisionHandler(.allow)
            } else {
                print("Cancelling navigation to \(url)")
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}





extension URL {
    /// Returns a new URL by adding the query items, or nil if the URL doesn't support it.
    /// URL must conform to RFC 3986.
    func appendQueryParams(_ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            // URL is not conforming to RFC 3986 (maybe it is only conforming to RFC 1808, RFC 1738, and RFC 2732)
            return nil
        }
        // append the query items to the existing ones
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        
        // return the url from new url components
        return urlComponents.url
    }
}
