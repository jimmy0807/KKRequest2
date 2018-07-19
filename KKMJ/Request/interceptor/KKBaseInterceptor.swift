//
//  KKBaseInterceptor.swift
//  KKMJ
//
//  Created by jimmy on 2018/7/16.
//  Copyright © 2018年 VCredit. All rights reserved.
//

import UIKit

open class KKBaseInterceptor<T> : NSObject
{
    func willStart() -> Bool { return true }
    func willExecute() -> Bool { return true }
    func onReceieve(object : T) -> KKBaseInterceptorResult? { return nil }
    func onError() -> KKBaseInterceptorResult? { return nil }
    func getHeaders() -> [String : String]? { return [:] }
}
