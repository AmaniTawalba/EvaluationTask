//
//  APIFile.swift
//
//  Created by Amani Tawalbeh on 6/9/18.
//  Copyright © 2019 Amani Tawalbeh. All rights reserved.
//

import UIKit

/**
This struct for all files to upload them
*/
struct APIFile: Codable {
    let name:String //API Key
    let fileName:String
    let data:Data
    let mimeType:String
}
