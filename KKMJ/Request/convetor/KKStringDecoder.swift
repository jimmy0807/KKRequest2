//
//  KKStringDecoder.swift
//  KKMJ
//
//  Created by jimmy on 2018/7/16.
//  Copyright © 2018年 VCredit. All rights reserved.
//

import UIKit

open class KKStringDecoder : KKBaseDecoder
{
    override
    open func decode(value: Data) -> Any?
    {
        return String(data: value, encoding: .utf8)
    }
}
