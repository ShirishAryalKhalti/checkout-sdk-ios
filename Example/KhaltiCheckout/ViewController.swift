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
        setUpView()
        
        khalti = Khalti.init(config: KhaltiPayConfig(publicKey:"live_public_key_979320ffda734d8e9f7758ac39ec775f", pIdx:"dh5bBcwa4q4PGrfVStxFdG",environment:Environment.TEST), onPaymentResult: {(paymentResult,khalti) in
            khalti?.close()
            //            khalti?.close()
            
            
        }, onMessage: {(onMessageResult,khalti) in
            let shouldVerify = onMessageResult.needsPaymentConfirmation
            if shouldVerify {
                khalti?.verify()
            }
            
            
        }, onReturn: {(khalti) in
            
        })
    }
    
    private func setUpView(){
        
        
        let publicKeyTextView = CustomTextFieldView(placeHolder: "Public Key")
        publicKeyTextView.translatesAutoresizingMaskIntoConstraints = false // Ensure this is set to false
        self.view.addSubview(publicKeyTextView)

        
        // Create UITextView
//        let publicKeyTextView = UITextView()
//        publicKeyTextView.translatesAutoresizingMaskIntoConstraints = false
//        publicKeyTextView.text = ""
//        publicKeyTextView.font = UIFont.systemFont(ofSize: 16)
//        publicKeyTextView.textColor = UIColor.black
//        publicKeyTextView.backgroundColor = UIColor.blue.withAlphaComponent(0.1) // Set
//        publicKeyTextView.isEditable = true
//        publicKeyTextView.isScrollEnabled = true
//        
//        // Add to the view
        
        // Set Auto Layout constraints for publicKeyTextView
        NSLayoutConstraint.activate([
            publicKeyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            publicKeyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            publicKeyTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            publicKeyTextView.heightAnchor.constraint(equalToConstant: 70) // Adjust height as needed
        ])
        
        let pIdxTextView = CustomTextFieldView(placeHolder: "PIDX")
        pIdxTextView.translatesAutoresizingMaskIntoConstraints = false // Ensure this is set to false
//        self.view.addSubview(pIdxTextView)
//        // Create UITextView
//        let pIdxTextView = UITextView()
//        pIdxTextView.translatesAutoresizingMaskIntoConstraints = false
//        pIdxTextView.text = ""
//        pIdxTextView.font = UIFont.systemFont(ofSize: 16)
//        pIdxTextView.textColor = UIColor.black
//        pIdxTextView.textAlignment = .left
//        pIdxTextView.backgroundColor = .purple
//        pIdxTextView.isEditable = true
//        pIdxTextView.isScrollEnabled = true
//        
        // Add to the view
        self.view.addSubview(pIdxTextView)
        
        NSLayoutConstraint.activate([
            pIdxTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            pIdxTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            pIdxTextView.topAnchor.constraint(equalTo: publicKeyTextView.bottomAnchor, constant: 20), // Set top to be below publicKeyTextView
            pIdxTextView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // Create the button
        let button = UIButton(type: .system)
        button.setTitle("Click Me", for: .normal)
        button.backgroundColor = .purple.withAlphaComponent(0.1)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        
        // Add the button to the view
        view.addSubview(button)
        
        // Set up Auto Layout constraints
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: pIdxTextView.bottomAnchor, constant: 30), // Position the button below pIdxTextView
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    }
    
    @objc func buttonTapped() {
        
        khalti?.open(viewController: self)
        
        
    }
    
}





class CustomTextFieldView: UIView {
    var placeHolder:String?
    
    // First UITextField
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter text 1"
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.backgroundColor = UIColor.blue.withAlphaComponent(0.1) // Set

        return textField
    }()
    
    // Second UITextField
    let label:  UILabel = {
        let label = UILabel()
        label.text = "asdfsdafs"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        
        label.font = UIFont.systemFont(ofSize: 14) // Adjust font size if necessary
        return label
    }()
    
    init(placeHolder:String){
        super.init(frame: .zero)
        self.placeHolder = placeHolder
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    private func setupUI() {
        addSubview(label)
        addSubview(textField)
      
        label.text = placeHolder
        NSLayoutConstraint.activate([
            // Constraints for firstTextField
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            

            
            
            // Constraints for secondTextField
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
     
}
