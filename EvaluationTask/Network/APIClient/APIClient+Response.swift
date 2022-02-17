//
//  APIClient+Response.swift
//  Structure
//
//  Created by Amani Tawalbeh on 11/10/18.
//  Copyright © 2019 Amani Tawalbeh. All rights reserved.
//

import Foundation


/**
This class for all API's which handle the response of API after requesting it
*/

extension APIClient {
    
    //MARK:- Response
    static func Response<T: Decodable, F: Decodable>(dataResponse:DataResponse<Data>,Api: API, progress: ((Progress) -> ())? = nil, completion: @escaping (T?,_ response:DataResponse<Data>?,_ dataStatus :DataStatus) -> (), failed: @escaping (F?) -> ()){
        DispatchQueue.main.async {
            //check if url is valied
            guard let url = Api.url else {
                print("request failed: Can't find URL")
                failed(nil)
                return
            }
            
            switch dataResponse.result {
            case .success:// 200 ... 300
                if let data = dataResponse.result.value {
                    //set data status
                    let cachedData = getCachedData(Api: Api)
                    let dataStatus = cachedData == nil ? DataStatus.newData : ( cachedData == data ? DataStatus.duplicateData : DataStatus.dataNotMatched)
                    
                    //cache response
                    if Api.method == HTTPMethod.get ,
                        Api.ignorCache == false ,
                        let resp = dataResponse.response,
                        let req = dataResponse.request{
                        let cachedURLResponse = CachedURLResponse(response: resp, data: data , userInfo: nil, storagePolicy: .allowed)
                        URLCache.shared.storeCachedResponse(cachedURLResponse, for: req)
                    }
                    
                    do {
                        let obj = try JSONDecoder().decode(T.self, from: data)
                        completion(obj,dataResponse,dataStatus)
                    } catch let jsonErr {
                        completion(nil,dataResponse,dataStatus)
                        print("Failed to decode json:", jsonErr)
                        print("JSON",JSON(fromData: data) ?? String.init(data: data, encoding: .utf8) ?? "")
                    }
                    
//                    guard let preetyResponse = dataResponse.data?.prettyPrintedJSONString else {return}
//                    print("===========\n\nResponse\n \(preetyResponse)\n\n===========")
                }else{
                    completion(nil,nil,DataStatus.unknown)
                }
            case .failure(let error):
                print(error)
                if let data = dataResponse.data {
                    do {
                        let obj = try JSONDecoder().decode(F.self, from: data)
                        NotificationCenter.default.post(name: .requestFailed, object: obj, userInfo: ["url":url,"statusCode":dataResponse.response?.statusCode ?? 0])
                        failed(obj)
                        
                    } catch let jsonErr {
                        print("Failed to decode json:", jsonErr)
                        NotificationCenter.default.post(name: .requestFailed, object: data, userInfo: ["url":url,"statusCode":dataResponse.response?.statusCode ?? 0])
                        failed(nil)
                    }
                    print("Failed URL: ",url.absoluteString)
                    print("Failed response: ",String.init(data: data, encoding: .utf8) ?? "")
                }else{
                    NotificationCenter.default.post(name: .requestFailed, object: nil, userInfo: ["url":url,"statusCode":dataResponse.response?.statusCode ?? 0])
                    failed(nil)
                }
            }
        }
    }
    
    //MARK:- Data Status
    enum DataStatus {
        case unknown,newData,cachedData,duplicateData,dataNotMatched
    }
    
    //MARK:- Helper
    static func JSON(fromData data:Data) -> Any? {
        do {
            var json:Any?
            json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
            if json == nil {
                json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String:Any]]
            }
            return json
        } catch {
            print("Something went wrong")
        }
        return nil
    }
    
    static func isCached(Api:API) -> Bool{
        return getCachedData(Api: Api) != nil
    }
    
    fileprivate static func getCachedData(Api:API) -> Data?{
        if Api.method == HTTPMethod.get ,
            Api.ignorCache == false {
            
            //check if url is valied
            guard let url = Api.url else {
                print("request failed: Can't find URL")
                return nil
            }
            
            //setup URLRequest
            let request = Api.skipInvalidCertificate ?  sessionManager.request(url, method: Api.method, parameters: Api.parameter, encoding: JSONEncoding.default, headers: Api.header) :
                Alamofire.request(url, method: Api.method, parameters: Api.parameter, encoding: JSONEncoding.default, headers: Api.header)
            if let authenticate = Api.authenticate {
                request.authenticate(usingCredential: authenticate)
            }
            
            //Cache
            if let req = request.request,
                let cachedResponse = URLCache.shared.cachedResponse(for: req){
                return cachedResponse.data
            }
        }
        return nil
    }
    
    //handel failed
    //    NotificationCenter.default.addObserver(self, selector: #selector(requestFailed(notification:)), name: .requestFailed, object: nil)
    
    //    @objc func requestFailed(notification: NSNotification) {
    //        if let userInfo = notification.userInfo,
    //            let url = userInfo["url"] as? URL,
    //            url.absoluteString.hasPrefix(""){
    //        }
    //    }
}

extension Notification.Name {
    static let requestFailed = Notification.Name("requestFailed")
    static let removePopUpMenu = Notification.Name("removePopUpMenu")
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}
