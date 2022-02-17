//
//  HomeViewController+Presenter.swift
//  EvaluationTask
//
//  Created by Amani Tawalbeh on 2/17/22.
//

import Foundation
extension HomeViewController :  HomeViewPresenter {
    func requestSuccessful(_ data: ResponseModel) {
        self.responseData = data
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
    }
    func requestFailed(_ error:String) {
        Dialogs.showAlert("Error", message: error) {
            
        }
    }
}
