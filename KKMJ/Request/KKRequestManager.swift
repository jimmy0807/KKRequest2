//
//  KKRequestManager.swift
//  KKMJ
//
//  Created by jimmy on 2018/7/16.
//  Copyright © 2018年 VCredit. All rights reserved.
//

import UIKit
import Alamofire

open class KKRequestManager: NSObject
{
    var requestArray = [Request]()
    
    static let instance = KKRequestManager()
    public var baseUrl = ""
    public var timeout = TimeInterval(60)
    public var decoder : KKBaseDecoder = KKJsonDecoder()
    public var interceptor : KKBaseInterceptor?
    public var requestMethod = KKRequestMethod.POSTBODY
    
    open class func shared() -> KKRequestManager
    {
        return instance
    }
    
    @discardableResult open func add(_ request : Request) -> KKRequestManager
    {
        requestArray.append(request)
        
        return self
    }
    
    @discardableResult open func remove(_ request : Request) -> KKRequestManager
    {
        if let index = requestArray.index(where: { $0 === request })
        {
            requestArray.remove(at: index)
        }
        
        return self
    }
    
    @discardableResult open func setRequestMethod(_ method : KKRequestMethod) -> KKRequestManager
    {
        requestMethod = method
        
        return self
    }
    
    @discardableResult open func setInterceptor(_ interceptor : KKBaseInterceptor) -> KKRequestManager
    {
        self.interceptor = interceptor

        return self
    }
    
    @discardableResult open func setBaseUrl(_ url : String) -> KKRequestManager
    {
        baseUrl = url
        
        return self
    }
    
    @discardableResult open func setTimeOut(_ timeout : TimeInterval) -> KKRequestManager
    {
        self.timeout = timeout
        
        return self
    }
    
    @discardableResult open func setDecoder(_ decoder : KKBaseDecoder) -> KKRequestManager
    {
        self.decoder = decoder
        
        return self
    }
}

