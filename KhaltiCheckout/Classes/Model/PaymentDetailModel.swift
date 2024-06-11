//
//  PaymentDetailModel.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/11/24.
//

import Foundation

struct PaymentDetailModel: Codable {
    let id: Int
    let name: String
    let email: String
    let profilePictureURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case profilePictureURL = "profile_picture_url"
    }
}

