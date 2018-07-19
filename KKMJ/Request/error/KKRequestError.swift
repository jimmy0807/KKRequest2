//
//  KKRequestError.swift
//  KKMJ
//
//  Created by jimmy on 2018/7/18.
//  Copyright © 2018年 VCredit. All rights reserved.
//

import UIKit

public enum APIRequestError : Int
{
    case convert = 2000
    case server = 2001
}

public struct KKRequestError
{
    var code = 0
    var message = ""
    
    var debugErrorCode = 0
    
    init(code : Int, message : String)
    {
        self.code = code
        self.message = message
    }
}
