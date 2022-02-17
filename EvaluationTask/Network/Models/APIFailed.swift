//
//  APIFailed.swift
//
//  Created by Amani Tawalbeh on 6/9/18.
//  Copyright © 2019 Amani Tawalbeh. All rights reserved.
//

import UIKit


/**
This struct for all API's when response Failed
*/
struct APIFailed : Codable {
    //MARK:- property
    var alert:String?
    var code:Int?
    
    
    //MARK:- alias key
    private enum CodingKeys : String, CodingKey {
        case code
        case alert = "description"
    }
    
    
    //MARK:- save and load object
    func save(key:String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    
    init(key:String) {
        let defaults = UserDefaults.standard
        if let saved = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let data = try? decoder.decode(APIFailed.self, from: saved) {
                self = data
                return
            }
        }
        self = APIFailed.init()
    }
    
    init() {
        
    }
    
    static func remove(key:String){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
}
