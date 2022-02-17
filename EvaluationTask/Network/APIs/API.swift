//
//  API.swift
//
//  Created by Amani Tawalbeh on 6/9/18.
//  Copyright © 2019 Amani Tawalbeh. All rights reserved.
//

import Foundation

/**
 This class for all API's which seperate each API to base url then first route, second route and finally last route and each API what parameters it may take
 */

enum API {
    
    static let domain = "https://tthomeauto.herokuapp.com"
    
    
    case ahliEvaluation
    
    var route : String {
        var url = API.domain
        switch self {
        case .ahliEvaluation:
            url = url.appending("/ahliEvaluation74")
        }
        return url
    }
    
    var url : URL? {
        var url = route
        switch self {
        case .ahliEvaluation:
            url = url.appending("/")
        }
        
        return URL.init(string: url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? "")
    }
    
}

