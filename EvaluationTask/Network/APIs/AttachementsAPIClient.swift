//
//  AttachementsAPIClient.swift
//  BTITDashboard
//
//  Created by Amani Tawalbeh on 5/13/19.
//  Copyright © 2019 BlessedTreeIT. All rights reserved.
//

import Foundation

/**
 This class for upload attacment Multipart API's which handle all functions that will help requesting and API
 */

class AttachementsAPIClient {
    
    typealias CompletionHandler = (_ success:Bool,_ IsOTPRequired:Bool,_ responseData:SelfRegistrationResponse?) -> Void
    
    static func uploadAttachment(registerData : selfRegistrationFormData,idImage: [UploadSelfRegistrationImage],isConfirm:Bool,OTP:Int?, completionHandler: @escaping CompletionHandler){
        
        let urlString = API.domain+"Wallets/CustomerSelfCreateWallet"
        var params = [String: Any]()
        params ["CustomerName"]  = "\(registerData.firstName) \(registerData.secondName) \(registerData.thirdName) \(registerData.lastName)"
        params ["CustomerNationalityId"] = registerData.nationalityID
        params ["CustomerIdentityTypeId"] = registerData.idType
        params ["CustomerID"] =  registerData.idNumber.replacedArabicDigitsWithEnglish
        params ["CustomerPhoneNumber"] =  registerData.phoneNumber.replacedArabicDigitsWithEnglish
        params ["WalletAliasName"] =  registerData.nickName
        params ["CustomerGenderId"] = registerData.genderID
        params ["BirthDate"] =  registerData.birthDate
        params ["CustomerEmail"] = registerData.email
        params ["DocumentNumber"] =  registerData.documentNumber.replacedArabicDigitsWithEnglish
        params ["IdentificationExpiryDate"]  = registerData.documentExpiryDate
        params ["CustomerAddress"] = registerData.address
        params ["CustomerOtherJob"] = registerData.enterOccupation
        params ["IncomeId"]  = (registerData.monthlyIncomeID == 0 ? "" : registerData.monthlyIncomeID)
        params ["HasBankAccount"] = registerData.haveBank ? "true" : "false"
        params ["IsActualBeneficiary"] =  registerData.isRealBeneficiary ? "true" : "false"
        params ["BeneficiaryID"] =  registerData.beneficiaryIDNumber
        params ["BeneficiaryName"]  = registerData.beneficiaryName
        params ["BeneficiaryIdentityTypeId"] = registerData.beneficiaryIDType == 0 ? "" : registerData.beneficiaryIDType
        params ["CustomerCityId"] =  (registerData.customerCityId == 0 ? "" :registerData.customerCityId)
        params["OTP"] = OTP ?? nil
        params["SectorId"] = registerData.sectorID
        params["JobTitleId"] = registerData.jobTitleID
        params["SectorTypeId"] = registerData.sectorTypeID
        params["MentionCompanyNameAndAddress"] = registerData.companyName
        params["PurposeOfOpeningTheWalletId"] = registerData.purposeID
        params["IsConfirmed"] = isConfirm
        params["OtherPhoneNumber"] = registerData.SecondaryPhone
        params["BeneficiaryDocumentNumber"] = registerData.beneficiaryDocumentNumber
        params["BeneficiaryDocumentexpirydate"] = registerData.beneficiaryDocumentExpiryDate
        params["BeneficiaryDateOfBirth"] = registerData.beneficiaryBirthDate
        params["BeneficiaryPhonenumber"] = registerData.beneficiaryPhoneNumber
        params["BeneficiaryTypeOfRelationship"] = registerData.typeOfRelationship
        params["BeneficiaryPurposeOfTheRelationship"] = registerData.purposeOfTheRelationship
        params["BeneficiaryWorkaddress"] = registerData.beneficiaryWorkAddress
        params["BeneficiaryNationalityId"] = registerData.beneficiaryNationalityID == 0 ? "" : registerData.beneficiaryNationalityID
        params["BeneficiaryResidenceAddress"] = registerData.beneficiaryAddress
        params["BeneficiaryGenderId"] = registerData.beneficiaryGenderID == 0 ? "" : registerData.beneficiaryGenderID
        params["BeneficiaryEmail"] = registerData.beneficiaryEmail
        params["BeneficiarySectorId"] = registerData.beneficiarysectorID == 0 ? "" : registerData.beneficiarysectorID
        params["BeneficiaryJobTitleId"] = registerData.beneficiaryjobTitleID == 0 ? "" : registerData.beneficiaryjobTitleID
        params["BeneficiarySectorTypeId"] = registerData.beneficiarysectorTypeID == 0 ? "" : registerData.beneficiarysectorTypeID
        for (i, index) in idImage.enumerated() {
            let stringCoutn = String(i)
            let paramsName = "FileData[\(stringCoutn)].CategoryId"
            params [paramsName] = index.code
        }
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        APIManager.upload(multipartFormData: { (multipartFormData) in
            
            
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                print("the  data  value  = \([value]) and key = \(key)")
                
            }
            for i in idImage {
                multipartFormData.append(i.AllData.data, withName: i.AllData.name , fileName: i.AllData.fileName, mimeType: i.AllData.mimeType)
            }
            
        }, usingThreshold: UInt64.init(), to: urlString, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                        
                        do {
                            let json = try? JSONDecoder().decode(SelfRegistrationResponse.self,from:data)
                            let issucceeded = json?.isSuccess
                            let isOTPRequired = json?.isOTPRequired
                            if issucceeded == true {
                                completionHandler(issucceeded ?? false, isOTPRequired ?? false, json)
                                
                            } else {
                                completionHandler(issucceeded ?? false, isOTPRequired ?? false, json)
                            }
                        }//End Do
                        catch (_)
                        {
                            Dialogs.dismiss()
                            Dialogs.showError()
                        }
                        
                    }//End Main If
                    
                }//End result
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                
            }
        }
        
    }
    
    
    private static var APIManager : Alamofire.SessionManager = {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            API.unsecureDomain: .disableEvaluation
        ]
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let man = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return man
    }()
    
    
    
    typealias DocumentCompletionHandler = (_ success:Bool,_ responseData:UploadMissingDocResponse?) -> Void
    
    static func uploadDocument(idImage: [UploadSelfRegistrationImage],documentNumber:String, completionHandler: @escaping DocumentCompletionHandler){
        
        let urlString = API.domain+"Wallets/UpdateWalletAttachments"
        var params = [String: Any]()
        params["DocumentNumber"] = documentNumber
        for (i, index) in idImage.enumerated() {
            let stringCoutn = String(i)
            let paramsName = "FileData[\(stringCoutn)].CategoryId"
            params [paramsName] = index.code
        }
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        APIManager.upload(multipartFormData: { (multipartFormData) in
            
            
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                print("the  data  value  = \([value]) and key = \(key)")
                
            }
            for i in idImage {
                multipartFormData.append(i.AllData.data, withName: i.AllData.name , fileName: i.AllData.fileName, mimeType: i.AllData.mimeType)
            }
            
        }, usingThreshold: UInt64.init(), to: urlString, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                        
                        do {
                            let json = try? JSONDecoder().decode(UploadMissingDocResponse.self,from:data)
                            let issucceeded = json?.isSuccess
                            if issucceeded == true {
                                completionHandler(issucceeded ?? false , json)
                                
                            } else {
                                completionHandler(issucceeded ?? false, json)
                            }
                        }//End Do
                        catch (_)
                        {
                            Dialogs.dismiss()
                            Dialogs.showError()
                        }
                        
                    }//End Main If
                    
                }//End result
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                
            }
        }
        
    }
    
    static func uploadRemittanceDocument(idImage: [UploadSelfRegistrationImage], logId: String, completionHandler: @escaping DocumentCompletionHandler){
        
        let urlString = API.domain+"MusharbashRemittance/VerficationRemit"
        var params = [String: Any]()
        params["LogId"] = logId.aesEncrypt()
        for (i, index) in idImage.enumerated() {
            let stringCoutn = String(i)
            let paramsName = "FileData[\(stringCoutn)].CategoryId"
            params [paramsName] = index.code
        }
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Cookie": "ASP.NET_SessionId=\(Manager.shared.account?.sessionId ?? "")"
        ]
        
        APIManager.upload(multipartFormData: { (multipartFormData) in
            
            
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                print("the  data  value  = \([value]) and key = \(key)")
                
            }
            for i in idImage {
                multipartFormData.append(i.AllData.data, withName: i.AllData.name , fileName: i.AllData.fileName, mimeType: i.AllData.mimeType)
            }
            
        }, usingThreshold: UInt64.init(), to: urlString, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                        
                        do {
                            let json = try? JSONDecoder().decode(UploadMissingDocResponse.self,from:data)
                            let issucceeded = json?.isSuccess
                            if issucceeded == true {
                                completionHandler(issucceeded ?? false , json)
                                
                            } else {
                                completionHandler(issucceeded ?? false, json)
                            }
                        }//End Do
                        catch (_)
                        {
                            Dialogs.dismiss()
                            Dialogs.showError()
                        }
                        
                    }//End Main If
                    
                }//End result
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                
            }
        }
        
    }
}
