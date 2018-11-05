//
//  KKBaseDecoder.swift
//  KKMJ
//
//  Created by jimmy on 2018/7/16.
//  Copyright © 2018年 VCredit. All rights reserved.
//

import UIKit

open class KKBaseDecoder<T> : NSObject
{
    open func decode(value : Data) -> T? { fatalError("请实现KKBaseDecoder的decode") }
}
