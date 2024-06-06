
//
//  KhaltiWebViewController.swift
//  Khalti
//
//  Created by Mac on 2/20/24.
//

import UIKit
import WebKit

class KhaltiCheckOutWebViewController: UIViewController,WKNavigationDelegate, WKUIDelegate {
    var wkWebView: WKWebView = WKWebView()
    var request:URLRequest?

    override func viewDidLoad() {
        super.viewDidLoad()
        wkWebView.backgroundColor = UIColor.lightGray
        wkWebView.frame = view.bounds
        wkWebView.center = view.center
        wkWebView.isOpaque = false
        
        // Initialize WKWebView with a configuration
          let configuration = WKWebViewConfiguration()
          wkWebView = WKWebView(frame: .zero, configuration: configuration)
          
          wkWebView.backgroundColor = UIColor.lightGray
          wkWebView.translatesAutoresizingMaskIntoConstraints = false
          view.addSubview(wkWebView)
        
          
          NSLayoutConstraint.activate([
              wkWebView.topAnchor.constraint(equalTo: view.topAnchor),
              wkWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
              wkWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              wkWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
          ])
        let url = URL(string: "https://khalti.com")
        request = URLRequest(url: url!)
        loadRequest()
        // Do any additional setup after loading the view.
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

}
