//
//  KKJsonDecoder.swift
//  KKMJ
//
//  Created by jimmy on 2018/7/16.
//  Copyright © 2018年 VCredit. All rights reserved.
//

import UIKit
import SwiftyJSON

open class KKJsonDecoder<T> : KKBaseDecoder<T>
{
    override
    open func decode(value: Data) -> T?
    {
        return JSON(value) as? T
    }
}



