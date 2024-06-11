
//
//  KhaltiWebViewController.swift
//  Khalti
//
//  Created by Mac on 2/20/24.
//

import UIKit
import WebKit

class KhaltiPaymentViewController: UIViewController {
    var wkWebView: WKWebView = WKWebView()
    var request:URLRequest?
    var config:KhaltiPayConfig?
    var onReceived: ((String) -> Void)?
    let loadingView = CustomLoadingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        showCustomDialog()
        loadingView.startLoading()
//        // Set up the toolbar
//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: view.frame.size.height - 44, width: view.frame.size.width, height: 44))
//        toolbar.barStyle = .default
//        view.addSubview(toolbar)
//        
//        // Add flexible space to push button to the right
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        
//        // Add back button
//        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
//        
//        toolbar.items = [flexibleSpace, backButton]
        
//        createPaymentWebView()
        
                // Do any additional setup after loading the view.
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 150),
            loadingView.heightAnchor.constraint(equalToConstant: 100)
        ])
        loadingView.isHidden = true
    }
    
    private func showCustomDialog(){
            let dialogView = CustomDialogView()
            dialogView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(dialogView)
            
            NSLayoutConstraint.activate([
                dialogView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                dialogView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                dialogView.widthAnchor.constraint(equalToConstant: 300),
                dialogView.heightAnchor.constraint(equalToConstant: 200)
            ])
            
            dialogView.configure(message: "Are you sure you want to continue?", buttonTitle: "OK") {
                print("Button tapped")
                // Dismiss the dialog
                dialogView.removeFromSuperview()
            }
        
    }
    
    @objc func backButtonTapped() {
        // Handle back button tap here
        // For example, present another view controller or perform any action
        let alertController = UIAlertController(title: "Back Button Tapped", message: "You tapped the back button.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func getPaymentUrl() -> URL?{
        let urlEnv = (config?.isProd() ?? false) ?  Url.BASE_PAYMENT_URL_PROD : Url.BASE_PAYMENT_URL_STAGING
        
        let url = URL(string:urlEnv.rawValue)?.appendQueryParams([URLQueryItem(name: "pidx", value: config?.pIdx ?? "")])
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
    
    
   
    func createPaymentWebView(){
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
        config = KhaltiGlobal.getKhaltiPayconfig()
        
        
        
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
    }
}

// MARK: - WebView Delegates function

extension KhaltiPaymentViewController :WKNavigationDelegate, WKUIDelegate{
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



