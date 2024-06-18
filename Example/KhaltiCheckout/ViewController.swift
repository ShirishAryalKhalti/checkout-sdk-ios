//
//  ViewController.swift
//  KhaltiCheckout
//
//  Created by bikash giri on 05/13/2024.
//  Copyright (c) 2024 bikash giri. All rights reserved.
//

import UIKit
import KhaltiCheckout

class ViewController: UIViewController {
    var khalti:Khalti?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the button
        let button = UIButton(type: .system)
        button.setTitle("Click Me", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.brown, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        
        // Add the button to the view
        view.addSubview(button)
        
        // Set up Auto Layout constraints
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        khalti = Khalti.init(config: KhaltiPayConfig(publicKey:"live_public_key_979320ffda734d8e9f7758ac39ec775f", pIdx:"j2qD9YsiVBSXHW4riGjjKc",environment:Environment.TEST), onPaymentResult: {(paymentResult,khalti) in
            khalti?.close()
            
        }, onMessage: {(onMessage,khalti) in
            
            
        }, onReturn: {(khalti) in
           print("onreturn called")
        })
    }
    
    
    @objc func buttonTapped() {
        
        khalti?.open(viewController: self)
        
        
    }
    
}



