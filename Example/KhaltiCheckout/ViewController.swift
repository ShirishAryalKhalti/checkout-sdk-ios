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
        setUpView()
    }
    
    private func setUpView() {
        
        // ScrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)
        
        // Container View
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        
        // ImageView
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "seru")
        containerView.addSubview(imageView)
        
        // CustomTextFieldView for Public Key
        let publicKeyTextView = CustomTextFieldView(placeHolder: "Public Key")
        publicKeyTextView.translatesAutoresizingMaskIntoConstraints = false
        publicKeyTextView.addText(text: khalti?.config.publicKey ?? "")
        publicKeyTextView.textChanged = { text in
            self.khalti?.config.publicKey = text
            // Handle text changes here
        }
        containerView.addSubview(publicKeyTextView)
        
        // CustomTextFieldView for PIDX
        let pIdxTextView = CustomTextFieldView(placeHolder: "PIDX")
        pIdxTextView.translatesAutoresizingMaskIntoConstraints = false
        pIdxTextView.addText(text: khalti?.config.pIdx ?? "")
        pIdxTextView.textChanged = { text in
            self.khalti?.config.pIdx = text
            // Handle text changes here
        }
        containerView.addSubview(pIdxTextView)
        
//        // CustomRadioButton
//        let customRadioButton = CustomRadioButton(selectedEnvironment: "test")
//        customRadioButton.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(customRadioButton)
        
        // Button
        let button = UIButton(type: .system)
        button.setTitle("Pay RS. 22", for: .normal)
        button.backgroundColor = .blue.withAlphaComponent(0.1)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 25 // Adjust the corner radius as needed
        button.clipsToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(button)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // Constraints for ScrollView and Container View
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        // Constraints for ImageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 90),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        // Constraints for PublicKeyTextView
        NSLayoutConstraint.activate([
            publicKeyTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            publicKeyTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            publicKeyTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            publicKeyTextView.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        // Constraints for PIdxTextView
        NSLayoutConstraint.activate([
            pIdxTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            pIdxTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            pIdxTextView.topAnchor.constraint(equalTo: publicKeyTextView.bottomAnchor, constant: 20),
            pIdxTextView.heightAnchor.constraint(equalToConstant: 70),
        ])
        
//        // Constraints for CustomRadioButton
//        NSLayoutConstraint.activate([
//            customRadioButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
//            customRadioButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
//            customRadioButton.topAnchor.constraint(equalTo: pIdxTextView.bottomAnchor, constant: 20),
//            customRadioButton.heightAnchor.constraint(equalToConstant: 100),
//        ])
//        
        // Constraints for Button
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            button.topAnchor.constraint(equalTo: pIdxTextView.bottomAnchor, constant: 90),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -50),
            button.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    
    @objc func buttonTapped() {
        
        khalti?.open(viewController: self)
        
        
    }
    
}





class CustomTextFieldView: UIView,UITextFieldDelegate {
    var placeHolder:String?
    var textChanged: ((String) -> Void)?
    
    
    // First UITextField
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.backgroundColor = UIColor.blue.withAlphaComponent(0.1) // Set
        
        return textField
    }()
    
    // Second UITextField
    let label:  UILabel = {
        let label = UILabel()
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
    
    func addText(text:String){
        textField.text = text
    }
    
    private func setupUI() {
        
        addSubview(label)
        addSubview(textField)
        textField.delegate = self
        
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textChanged?(textField.text ?? "")
    }
    
}


class CustomRadioButton: UIView {
    
    var onSelected: ((String) -> Void)?
    var selectedEnvironment: String = "" // Initialize with an empty string or any default value
    
    // Radio Button 1
    lazy var prodButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("PROD", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        
        button.tintColor = .white
        
        
        
        
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "circle"), for: .normal)
            button.setImage(UIImage(systemName: "circle.fill"), for: .selected)
            
            
            
        } else {
            button.setImage(UIImage(named: "circle"), for: .normal)
            button.setImage(UIImage(named: "circle_filled"), for: .selected)
            
            
        }
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // Radio Button 2
    lazy var testButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("TEST", for: .normal)
        button.tintColor = .clear
        button.setTitleColor(.black, for: .selected)
        
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "circle"), for: .normal)
            button.setImage(UIImage(systemName: "circle.fill")?.withTintColor(.purple), for: .selected)
            
        } else {
            button.setImage(UIImage(named: "circle"), for: .normal)
            button.setImage(UIImage(named: "circle_filled"), for: .selected)
            
            
        }
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    init(selectedEnvironment: String) {
        self.selectedEnvironment = selectedEnvironment
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    @objc private func radioButtonTapped(_ sender: UIButton) {
        if sender == prodButton {
            prodButton.isSelected = true
            testButton.isSelected = false
            selectedEnvironment = "prod"
        } else if sender == testButton {
            prodButton.isSelected = false
            testButton.isSelected = true
            selectedEnvironment = "test"
        }
        onSelected?(selectedEnvironment)
    }
    
    private func setupUI() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Environment"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        
        addSubview(prodButton)
        addSubview(testButton)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            
            
            // Constraints for prodButton
            prodButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            prodButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            
            // Constraints for testButton
            testButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            testButton.topAnchor.constraint(equalTo: prodButton.bottomAnchor, constant: 10),
        ])
    }
}

