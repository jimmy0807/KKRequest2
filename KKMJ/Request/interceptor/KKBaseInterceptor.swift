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
    open func willStart() -> Bool { return true }
    open func willExecute() -> Bool { return true }
    open func onReceieve(object : T) -> KKBaseInterceptorResult? { return nil }
    open func onError() -> KKBaseInterceptorResult? { return nil }
    open func getHeaders() -> [String : String]? { return [:] }
}
