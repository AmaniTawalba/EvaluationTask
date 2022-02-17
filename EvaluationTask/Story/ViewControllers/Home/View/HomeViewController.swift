//
//  HomeViewController.swift
//  EvaluationTask
//
//  Created by Amani Tawalbeh on 2/17/22.
//

import UIKit

class HomeViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    
    /**
     This class for ....
     */
    
    //MARK: - Outlets
    @IBOutlet var tableView: UITableView!{
        didSet{
            tableView.register(UINib(nibName: "ListTVC", bundle: nil), forCellReuseIdentifier: "ListTVC")
            
        }
    }
    
    //MARK: - Variables
    lazy  var presenter = HomePresenter(self)
    
    var responseData = [ResponseModelElement]()
    var heightForRow =  100.0
    //MARK: - Class Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Helpers
    func setupView(){
        self.presenter.requestData()
    }
    
    
    //MARK: - Actions
    //MARK: - Functions
    //MARK: - TableView DataSource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.responseData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTVC", for: indexPath) as! ListTVC
        cell.messageLabel.text = responseData[indexPath.row].message ?? ""
        cell.extraLabel.text = "\(responseData[indexPath.row].extra ?? 0)"
        cell.extraLabel.isHidden =  responseData[indexPath.row].extra == 0 || responseData[indexPath.row].extra == nil ? true : false
        let chattype = responseData[indexPath.row].chattype
        switch chattype {
        case 1:
            cell.messageLabel.textColor = .green
            cell.extraLabel.textColor = .green
            heightForRow = 100.0
        case 2:
            cell.messageLabel.textColor = .red
            cell.extraLabel.textColor = .red
            heightForRow = 150.0
        default:
            print("It's Default")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }
}
