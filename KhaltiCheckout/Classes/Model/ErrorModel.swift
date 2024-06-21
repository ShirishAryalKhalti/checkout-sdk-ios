//
//  ErrorModel.swift
//  KhaltiCheckout
//
//  Created by Mac on 6/21/24.
//

import Foundation

enum FailureType{
    case ServerUnreachable,Httpcall,Generic,ParseError
}

struct ErrorModel{
    var statusCode:Int?
    var errorType:FailureType?
}
