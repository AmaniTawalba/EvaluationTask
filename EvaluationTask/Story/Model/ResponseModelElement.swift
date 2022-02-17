//
//  ResponseModelElement.swift
//  EvaluationTask
//
//  Created by Amani Tawalbeh on 2/17/22.
//

import Foundation

// MARK: - ResponseModelElement
struct ResponseModelElement: Codable {
    var id, chatid, chattype: Int?
    var message: String?
    var extra: Int?
}

typealias ResponseModel = [ResponseModelElement]
