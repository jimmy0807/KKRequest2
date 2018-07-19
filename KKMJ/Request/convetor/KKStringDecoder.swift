//
//  KKStringDecoder.swift
//  KKMJ
//
//  Created by jimmy on 2018/7/16.
//  Copyright © 2018年 VCredit. All rights reserved.
//

import UIKit

open class KKStringDecoder : KKBaseDecoder<String>
{
    override
    func decode(value: Data) -> String?
    {
        return String(data: value, encoding: .utf8)
    }
}
