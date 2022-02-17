//
//  HomeViewControllerPresenter.swift
//  EvaluationTask
//
//  Created by Amani Tawalbeh on 2/17/22.
//

import Foundation

protocol HomeViewPresenter : NSObjectProtocol{
    
    func requestSuccessful(_ data: ResponseModel)
    func requestFailed(_ error:String)
}


final class HomePresenter {
    weak fileprivate var viewPresenter : HomeViewPresenter?
    
    init(_ view:HomeViewPresenter) {
        viewPresenter = view
    }
    
    func requestData() {
        APIClient.request(api: API.ahliEvaluation) { [weak self] (responseData:ResponseModel?, response:DataResponse<Data>?, cache:APIClient.DataStatus) in
            guard let `self` = self else {
                return
            }
            if let response = responseData{
//                if ErrorHandler.isFailed("Error Data") {
//                    return
//                }
                self.viewPresenter?.requestSuccessful(response)
            }else {
                self.viewPresenter?.requestFailed(NSLocalizedString("Internal server Error", comment: "Server error"))
            }
        }
    }
    
}
