//
//  KKBaseCoveter.swift
//  KKMJ
//
//  Created by jimmy on 2018/7/16.
//  Copyright © 2018年 VCredit. All rights reserved.
//

import UIKit

open class KKBaseCoveter<U,V> : NSObject
{
    open func onReceieve(_ object : U) -> V?
    {
        fatalError("请实现KKBaseCoveter的onReceieve")
    }
}
