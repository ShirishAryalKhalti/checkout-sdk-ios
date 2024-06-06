//
//  OnMessage.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//

import Foundation

public class OnMessage {
    private var onMesagePayload:((OnMessagePayload,Khalti) -> ())
    init(onMesagePayload: @escaping (OnMessagePayload, Khalti) -> Void) {
        self.onMesagePayload = onMesagePayload
    }
}
