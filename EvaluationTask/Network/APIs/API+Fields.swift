//
//  API+Fields.swift
//  Structure
//
//  Created by Amani Tawalbeh on 11/9/18.
//  Copyright © 2019 Amani Tawalbeh. All rights reserved.
//

import Foundation
/**
 This class for API's which choose HTTPMethon, headers, parameters and files
 */


extension API {
    
    var method : Alamofire.HTTPMethod {
        switch self {
            
        case .ahliEvaluation:
            return .get
        }
    }
    var header : [String:String]? {
        switch self {
        case .ahliEvaluation:
            return ["Content-type": "application/x-www-form-urlencoded"]
        }
    }
    var parameter : [String:Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    var files : [APIFile]? {
        switch self {
        default:
            return nil
        }
    }
}

