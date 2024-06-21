
//
//  KhaltiWebViewController.swift
//  Khalti
//
//  Created by Mac on 2/20/24.
//

import UIKit
import WebKit
extension Notification.Name {
    static let notificationAction = Notification.Name("close")
    static let notificationType = Notification.Name("verify")
}

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
    var returnUrl:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        viewModel = KhaltiPaymentControllerViewModel(khalti:khalti)
        self.view.backgroundColor = .white
        addNavigationBar()
//        createPaymentWebView()
        setupLoadingView()
        self.verifyPaymentStatus()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .notificationAction, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .notificationType, object: nil)
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
    
    
    @objc func handleNotification(notification: Notification) {
        if notification.name == Notification.Name.notificationType {
            self.verifyPaymentStatus()
        }else{
            
            self.dismiss(animated: true)
        }
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
    
    deinit {
        // Remove observer
        NotificationCenter.default.removeObserver(self, name: .notificationAction, object: nil)
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default // Change status bar color to light
    }
    
    
    
    func createPaymentWebView(){
//        addNavigationBar()
//        wkWebView.backgroundColor = UIColor.lightGray
        wkWebView.frame = view.bounds
        wkWebView.center = view.center
        wkWebView.isOpaque = false
        
        // Initialize WKWebView with a configuration
        let configuration = WKWebViewConfiguration()
        wkWebView = WKWebView(frame: .zero, configuration: configuration)
        
        
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wkWebView)
       
        wkWebView.navigationDelegate = self
        
        
        
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                wkWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
                wkWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                wkWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                wkWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        } else {
            // Fallback on earlier versions
        }
        
       
       
        loadUrl()
        
    }
    
    private func loadUrl(){
        if let url = getPaymentUrl(){
            request = URLRequest(url: url)
            self.loadingView.startLoading()
            loadRequest()
            
        }
    }
    
    func addNavigationBar(){
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationBar)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        // Add constraints for the navigationBar
        navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        let navigationItem = UINavigationItem(title: "Payment Gateway")
        if #available(iOS 11.0, *) {
            
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            
            // Fallback on earlier versions
        }
        
        
        
        
        if #available(iOS 13.0, *) {
            let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
            backButton.tintColor = .black
            
            navigationItem.leftBarButtonItem = backButton
            
        } else {
            // Create a back button
            let backButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(backButtonTapped))
            backButton.tintColor = .black
            
            navigationItem.leftBarButtonItem = backButton
        }
        navigationBar.barTintColor = .white
        navigationBar.items = [navigationItem]
    }
}



// MARK: - WebView Delegates function

extension KhaltiPaymentViewController :WKNavigationDelegate, WKUIDelegate{
    // WKNavigationDelegate methods to handle errors
    
    func webView(_ webView:WKWebView, didFailProvisionalNavigation: WKNavigation!, withError error: any Error){
       
        self.loadingView.stopLoading()
        self.khalti?.onMessage(OnMessagePayload(event: OnMessageEvent.ReturnUrlLoadFailure, message:error.localizedDescription,code: nil, needsPaymentConfirmation: true),self.khalti)
    }
    

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let httpResponse = navigationResponse.response as? HTTPURLResponse {
            if let returnUrl ,(httpResponse.url?.description ?? "") .contains(returnUrl) {
                print("onReturn matched")
                self.verifyPaymentStatus()
                
            }
        }
        decisionHandler(.allow)
    }
    
}


extension KhaltiPaymentViewController:KhaltiPaymentViewControllerProtocol{
    func fetchPaymentDetail(){
        self.loadingView.startLoading()
        
            self.viewModel?.getPaymentDetail(onCompletion: { [weak self ] response in
                self?.returnUrl = response.returnUrl
                DispatchQueue.main.async {
                    self?.loadingView.stopLoading()
                    self?.loadUrl()
                    
                }
                
            }, onError: {[weak self] msg in
                print(msg)
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
                self?.khalti?.onPaymentResult(PaymentResult(status: response.status, payload: response), self?.khalti!)

            }
            
        }, onError: {[weak self] msg in
          
           print("error called")
        }
        )
        print("not called")
    }
}
