//
//  Dialogs.swift
//  Orange Money
//
//  Created by Amani Tawalbeh on 11/13/18.
//  Copyright © 2019 Amani Tawalbeh. All rights reserved.
//

import Foundation

class Dialogs {
    static func showAlert(_ title: String, message : String? = nil, callBack:(()->())? = nil) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (action:UIAlertAction) in
            callBack?()
        }))
        alert.show()
    }
}

