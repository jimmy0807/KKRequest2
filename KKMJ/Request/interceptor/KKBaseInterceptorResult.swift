//
//  KKBaseInterceptorResult.swift
//  KKMJ
//
//  Created by jimmy on 2018/7/17.
//  Copyright © 2018年 VCredit. All rights reserved.
//

import UIKit

public enum KKInterceptorResultEnum
{
    case NextSuccess
    case NextFailed
    case NextComplete
}

open class KKBaseInterceptorResult: NSObject
{
    open var code = 0;
    open var nextStep = KKInterceptorResultEnum.NextSuccess
    open var message = ""
    open var data : Any?
}
