//
//  ViewController.swift
//  KhaltiCheckoutExamples
//
//  Created by Mac on 6/6/24.
//

import UIKit
import KhaltiCheckout

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the button
               let button = UIButton(type: .system)
               button.setTitle("Click Me", for: .normal)
               button.backgroundColor = .systemBlue
               button.setTitleColor(.white, for: .normal)
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
    }
    



}

