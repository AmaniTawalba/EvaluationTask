//
//  APIClient.swift
//
//  Created by Amani Tawalbeh on 6/9/18.
//  Copyright © 2019 Amani Tawalbeh. All rights reserved.
//

import Foundation
/**
This class for all API's which handle all functions that will help requesting and API
*/

struct APIClient {
    
    //MARK:- cache
    static func limitCache(MemorySize memory:Int,DiskSize disk:Int) {
        URLCache.shared = URLCache(memoryCapacity: memory * 1024 * 1024, diskCapacity: disk * 1024 * 1024, diskPath: nil)
    }
    
    //MARK:- request
    @discardableResult static func request<T: Decodable>(api: API, completion: @escaping (T?,_ response:DataResponse<Data>?,_ dataStatus :DataStatus) -> ()) -> Bool {
        return request(api: api, completion: completion, failed: { (failed:APIFailed?) in
            print("Request failed")
        })
    }
    
    @discardableResult static func request<T: Decodable, F: Decodable>(api: API, completion: @escaping (T?,_ response:DataResponse<Data>?,_ dataStatus :DataStatus) -> (), failed: @escaping (F?) -> ()) -> Bool {
        //check if url is valied
        
        
               print("\n\n\nRequesting\n============\n\(api.url?.absoluteString ?? "")\n============\nAND PARAMS\n============\n\(api.parameter ?? [:])\n============\nAND HEADERS\n============\n\(api.header ?? [:])\n============\n\n\n")
               
        
        guard let url = api.url else {
            print("request failed: Can't find URL")
            return Alamofire.NetworkReachabilityManager.shared?.isReachable ?? false
        }
        
        //setup URLRequest
        let request = api.skipInvalidCertificate ?  sessionManager.request(url, method: api.method, parameters: api.parameter, encoding: api.parameterEncoding, headers: api.header) : Alamofire.request(url, method: api.method, parameters: api.parameter, encoding: api.parameterEncoding, headers: api.header)
        if let authenticate = api.authenticate {
            request.authenticate(usingCredential: authenticate)
        }
        
        if let timeout = api.timeout {
            request.session.configuration.timeoutIntervalForRequest = timeout
        }
        
        //Cache
        if api.method == HTTPMethod.get ,
            api.ignorCache == false ,
            let req = request.request,
            let cachedResponse = URLCache.shared.cachedResponse(for: req){
            let data = cachedResponse.data
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(obj,DataResponse.init(request: req, response: cachedResponse.response as? HTTPURLResponse, data: data, result: Result.success(data)) ,DataStatus.cachedData)
            } catch _ {
            }
        }
        
        //send request
        if Alamofire.NetworkReachabilityManager.shared?.isReachable ?? false == true {
            request.validate().responseData { (response) in
                Response(dataResponse: response, Api: api, completion: completion, failed: failed)
            }
            
//            if api. == .transferMoney {
//                request.validate().responseJSON { (response) in
//                    
//                }
//            }
            
        }
        return Alamofire.NetworkReachabilityManager.shared?.isReachable ?? false
    }
    
    // MARK:- upload
    @discardableResult static func uploadFile<T: Decodable, F: Decodable>(Api: API, completion: @escaping (T?,_ response:DataResponse<Data>?,_ dataStatus :DataStatus) -> (), failed: @escaping (F?) -> ()) -> Bool {
        return self.uploadFile(Api: Api, progress: nil, completion: completion, failed: failed)
    }
    
    @discardableResult static func uploadFile<T: Decodable, F: Decodable>(Api: API, progress: ((Progress) -> ())?, completion: @escaping (T?,_ response:DataResponse<Data>?,_ dataStatus :DataStatus) -> (), failed: @escaping (F?) -> ()) -> Bool {
        //check if url is valied
        guard let url = Api.url else {
            print("request failed: Can't find URL")
            return Alamofire.NetworkReachabilityManager.shared?.isReachable ?? false
        }
        
        //check if files is available
        guard let files = Api.files else {
            print("request failed: Can't find file")
            return Alamofire.NetworkReachabilityManager.shared?.isReachable ?? false
        }
        
        //upload
        if Alamofire.NetworkReachabilityManager.shared?.isReachable ?? false == true {
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                //setup files
                for file in files {
                    multipartFormData.append(file.data, withName: file.name, fileName: file.fileName, mimeType: file.mimeType)
                }
                
                //setup params
                guard let parameter = Api.parameter else {return}
                for (key, value) in parameter{
                    if let value = value as? String,
                        let data = value.data(using: String.Encoding.utf8){
                        multipartFormData.append(data, withName: key)
                    }
                }
            }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
               to: url,
               method: Api.method,
               headers: Api.header) { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    //add authenticate
                    if let authenticate = Api.authenticate {
                        upload.authenticate(usingCredential: authenticate)
                    }
                    
                    //setup progress
                    upload.uploadProgress(closure: { (progressValue) in
                        progress?(progressValue)
                    })
                    
                    //send request
                    upload.validate().responseData { (response) in
                        Response(dataResponse: response, Api: Api, progress: progress, completion: completion, failed: failed)
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        }
        
        return Alamofire.NetworkReachabilityManager.shared?.isReachable ?? false
    }
    
    //MARK:- Handle invalid certificate
    open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
        open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
            return ServerTrustPolicy.disableEvaluation
        }
    }
    
    static let sessionManager = SessionManager(delegate:SessionDelegate(), serverTrustPolicyManager:MyServerTrustPolicyManager(policies: [:]))
    
}

extension NetworkReachabilityManager {
    static let shared = NetworkReachabilityManager.init()
}
