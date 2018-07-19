//
//  KKBaseRequest.swift
//  KKMJ
//
//  Created by jimmy on 2018/6/5.
//  Copyright © 2018年 VCredit. All rights reserved.
//

import Foundation
import Alamofire

//enum APIRequestError: Error
//{
//    case network
//    case convert
//    case notSend
//    case alamofire(Error)
//    case invalidWithMessage(String)
//}

open class KKBaseRequest<U : Any,V : Any> : NSObject
{
    public typealias SuccessClosure = (_ data: V) -> Void
    public typealias FailedClosure = (_ error: KKRequestError) -> Void
    public typealias CompleteClosure = (_ isSend: Bool) -> Void
    public typealias Parameters = [String: String]
    
    var successClosure : SuccessClosure?
    var failedClosure : FailedClosure?
    var completeClosure : CompleteClosure?
    var requestParameters : Parameters = [:]
    var headParameters : Parameters = [:]

    @discardableResult
    open func execute() -> KKBaseRequest
    {
        return execute(nil)
    }
    
    @discardableResult
    open func execute(_ successClosure : SuccessClosure?) -> KKBaseRequest
    {
        self.successClosure = successClosure
        
        guard willStart() else {
            DispatchQueue.main.async {
                print("==== http not send ===== \(self)")
                self.completeClosure?(false)
            }
            
            return self
        }
        
        if let interceptor = getInterceptor()
        {
            guard interceptor.willStart() else {
                DispatchQueue.main.async {
                    print("==== interceptor http not send ===== \(self)")
                    self.completeClosure?(false)
                }
                
                return self
            }
            
            if let heads = interceptor.getHeaders()
            {
                headParameters = getHeaders()
                headParameters.merge(heads) { (current, _) -> String in current }
            }
        }
        
#if DEBUG
        if let data = mockData()
        {
            DispatchQueue.main.async {
                self.successClosure?(data)
            }
        }
        else
        {
            handleExecute()
        }
#else
       handleExecute()
#endif
        return self
    }
    
    func handleExecute()
    {
        Alamofire.SessionManager.default.session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = KKRequestManager.shared().timeout
        
        let request = Alamofire.request(getBaseUrl() + getSubUrl(), method: getRequestMethod(), parameters:getParameters(), headers: headParameters)
       
        KKRequestManager.shared().add(request)
        
        request.responseData { response in
            if case let .success(value) = response.result
            {
                self.handleSuccess(value: value)
            }
            else if case .failure(_) = response.result
            {
                print("==== http error: \(response.response?.statusCode ?? 0)")
                
                self.handleError()
            }
            
            self.completeClosure?(true)
            
            KKRequestManager.shared().remove(request)
        }
    }
    
    func handleSuccess(value : Data)
    {
        var target = getDecoder()?.decode(value: value)
        if let object = target
        {
            if let interceptor = self.getInterceptor()
            {
                if let result = interceptor.onReceieve(object: object)
                {
                    if result.nextStep == .NextFailed
                    {
                        self.failedClosure?(KKRequestError(code: result.code, message: result.message))
                        target = nil
                    }
                    else
                    {
                        target = result.data
                    }
                }
            }
            
            if let target = target as? U
            {
                if let conveter = getConveter()
                {
                    if let data = conveter.onReceieve(target) as? V
                    {
                        self.successClosure?(data)
                    }
                    else
                    {
                        self.failedClosure?(KKRequestError(code: APIRequestError.convert.rawValue, message: "内部发生错误"))
                    }
                }
                else
                {
                    if let data = self.onReceieve(target)
                    {
                        self.successClosure?(data)
                    }
                    else
                    {
                        self.failedClosure?(KKRequestError(code: APIRequestError.convert.rawValue, message: "内部发生错误"))
                    }
                }
            }
            else
            {
                self.failedClosure?(KKRequestError(code: APIRequestError.convert.rawValue, message: "内部发生错误"))
            }
        }
        else
        {
            self.failedClosure?(KKRequestError(code: APIRequestError.convert.rawValue, message: "内部发生错误"))
        }
    }
    
    func handleError()
    {
        if let interceptor = getInterceptor()
        {
            if let result = interceptor.onError()
            {
                self.failedClosure?(KKRequestError(code: result.code, message: result.message))
            }
            else
            {
                self.failedClosure?(KKRequestError(code: APIRequestError.server.rawValue, message: "服务器发生异常"))
            }
        }
        else
        {
            self.failedClosure?(KKRequestError(code: APIRequestError.server.rawValue, message: "服务器发生异常"))
        }
    }
    
    open func willStart() -> Bool
    {
        return true
    }
    
    open func getBaseUrl() -> String
    {
        return KKRequestManager.shared().baseUrl;
    }
    
    open func getRequestMethod() -> HTTPMethod
    {
        return .get;
    }
    
    open func getSubUrl() -> String
    {
        return ""
    }
    
    open func getParameters() -> Parameters
    {
        return requestParameters
    }
    
    open func getHeaders() -> Parameters
    {
        return headParameters
    }
    
    open func getInterceptor() -> KKBaseInterceptor<Any>?
    {
        return KKRequestManager.shared().interceptor
    }
    
    open func getDecoder() -> KKBaseDecoder<Any>?
    {
        return KKRequestManager.shared().decoder
    }
    
    open func getConveter() -> KKBaseCoveter<Any, Any>?
    {
        return nil
    }
    
    open func mockData() -> V?
    {
        return nil;
    }
    
    open func onReceieve(_ data : U) -> V?
    {
        if let value = data as? V
        {
            return value
        }
        
        return nil
        //fatalError("Subclasses need to implement the `onReceieve()` method.")
    }
    
    deinit {
        print("sdf")
    }
}

//block
extension KKBaseRequest
{
    @discardableResult open func onSuccess(_ closure : @escaping SuccessClosure) -> KKBaseRequest
    {
        self.successClosure = closure
        
        return self
    }
    
    @discardableResult open func onFailed(_ closure : @escaping FailedClosure) -> KKBaseRequest
    {
        self.failedClosure = closure
        
        return self
    }
    
    @discardableResult open func onComplete(_ closure : @escaping CompleteClosure) -> KKBaseRequest
    {
        self.completeClosure = closure
        
        return self
    }
}
