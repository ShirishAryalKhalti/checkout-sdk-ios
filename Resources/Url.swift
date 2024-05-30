//
//  Url.swift
//  KhaltiCheckout
//
//  Created by Mac on 5/30/24.
//

import Foundation
enum class Url(val value: String) {
    BASE_KHALTI_URL_PROD("https://khalti.com/api/v2/"),
    BASE_KHALTI_URL_STAGING("https://dev.khalti.com/api/v2/"),
    BASE_PAYMENT_URL_PROD("https://pay.khalti.com/"),
    BASE_PAYMENT_URL_STAGING("https://test-pay.khalti.com/"),
}
