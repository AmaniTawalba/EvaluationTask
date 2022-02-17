//
//  ErrorHandler.swift
//  Orange Money
//
//  Created by Amani Tawalbeh on 11/13/18.
//  Copyright © 2019 Amani Tawalbeh. All rights reserved.
//

import Foundation

class ErrorHandler {
    
    static let shared = ErrorHandler()
    
    static func isFailed(_ object:String) -> Bool {
        if object.count > 0 {
            let message = object
            Dialogs.showAlert(message)
            return true
        }
        return false
    }
    
    
}
