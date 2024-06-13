
//
//  KhaltiWebViewController.swift
//  Khalti
//
//  Created by Mac on 2/20/24.
//

import UIKit
import WebKit

protocol KhaltiPaymentViewControllerProtocol{
    func fetchPaymentDetail()
    func verifyPaymentStatus()
}

class KhaltiPaymentViewController: UIViewController {
    var khalti:Khalti?
    private var wkWebView: WKWebView = WKWebView()
    private var request:URLRequest?
    private var onReceived: ((String) -> Void)?
    private var loadingView = CustomLoadingView()
    private var viewModel:KhaltiPaymentControllerViewModel?
    private let dialogView = CustomDialogView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        viewModel = KhaltiPaymentControllerViewModel(khalti:khalti)
        //        showCustomDialog()
        self.fetchPaymentDetail()
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
    
    private func showCustomDialog(message:String,onTapped:@escaping () -> Void){
        dialogView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dialogView)
        
        NSLayoutConstraint.activate([
            dialogView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dialogView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dialogView.widthAnchor.constraint(equalToConstant: 300),
            dialogView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        dialogView.configure(message: message, buttonTitle: "OK") {
            print("Button tapped")
            onTapped()
            // Dismiss the dialog
            
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
        let config = self.khalti?.config
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
        
        
        
        
        NSLayoutConstraint.activate([
            wkWebView.topAnchor.constraint(equalTo: view.topAnchor),
            wkWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wkWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wkWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        if let url = getPaymentUrl(){
            request = URLRequest(url: url)
            self.loadingView.startLoading()
            loadRequest()
            
        }
    }
}

// MARK: - WebView Delegates function

extension KhaltiPaymentViewController :WKNavigationDelegate, WKUIDelegate{

    func webView(_ webView: WKWebView,didFinish navigation: WKNavigation!) {
        let khalti = KhaltiGlobal.khalti
        khalti?.onReturn(khalti!)
        print("3")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("4")
        if let httpResponse = navigationResponse.response as? HTTPURLResponse {
            if httpResponse.statusCode == 200{
                if httpResponse.url?.description == httpResponse.url?.description {
                    
                }
            }
            print("HTTP response received with status code: \(httpResponse.url)")
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


extension KhaltiPaymentViewController:KhaltiPaymentViewControllerProtocol{
    func fetchPaymentDetail(){
        self.loadingView.startLoading()
        viewModel?.getPaymentDetail(onCompletion: { [weak self ] response in
            DispatchQueue.main.async {
                self?.loadingView.stopLoading()
                self?.createPaymentWebView()
            }
           
        }, onError: {[weak self] msg in
            DispatchQueue.main.async{
                self?.loadingView.stopLoading()
                self?.showCustomDialog(message: msg,onTapped: {
                    self?.fetchPaymentDetail()
                    self?.dialogView.removeFromSuperview()
                }
                )
            }
          
        }
        )
    }
    
    func verifyPaymentStatus() {
        self.loadingView.startLoading()
        viewModel?.verifyPaymentStatus(onCompletion: { [weak self ] response in
            DispatchQueue.main.async {
                self?.loadingView.stopLoading()
            }
            
        }, onError: {[weak self] msg in
            DispatchQueue.main.async {
                self?.loadingView.stopLoading()
                self?.showCustomDialog(message: msg,onTapped: {
                    
                }
                )
            }
            
        }
        )
    }
}
