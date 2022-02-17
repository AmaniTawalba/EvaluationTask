//
//  API+Configurations.swift
//  Structure
//
//  Created by Amani Tawalbeh on 11/9/18.
//  Copyright © 2019 Amani Tawalbeh. All rights reserved.
//

import Foundation

/**
 This class for all API's which take JSON decoding type, authentecation, timeout, caching get API's and skip invalidation certificate
 */

extension API {
    
    var parameterEncoding : ParameterEncoding {
        switch self {
        
        default:
            return URLEncoding.default //JSONEncoding.default
        }
    }
    
    var authenticate : URLCredential? {
        switch self {
        default:
            /* Sample
             return URLCredential.init(user: "admin@domin.com", password: "pass", persistence: URLCredential.Persistence.forSession)
             */
            return nil
        }
    }
    
    var timeout : TimeInterval? {
        switch self {
        default:
            return 120
        }
    }
    
    var ignorCache : Bool {
        switch self {
        default:
            return true//false
        }
    }
    
    var skipInvalidCertificate : Bool {
        switch self {
        default:
            return false
        }
    }
    
}
