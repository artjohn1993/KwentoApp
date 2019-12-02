//
//  ProfileServices.swift
//  Kwento
//
//  Created by Art John on 19/11/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
import SwiftyJSON

class ProfileServices {

    let dataServices = CoreDataServices()
    var userInfo = [UserInfo]()
    var tokenServices = TokenServices()
    
    func getCurrentUser(completion: @escaping ([String:Any]?)->()) {
       
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        
        let id = userInfo[0].client_id
        let url = "\(PublicData.baseUrl)/api/accounts/current"
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        tokenServices.checkExpirationDate(completion: {
            Alamofire.request(url,
            method: .get,
            headers: header).responseJSON(completionHandler: { response in
                let data = response.result.value as? [String:Any]
                if response.response?.statusCode == 200 {
                    print("success")
                    completion(data)
                }
                else {
                    print("failed")
                    print(response.error)
                    print(response.data)
                    completion(nil)
                }
            })
        })
        
        
    }// end of get current user function
    
    func updateInfo(mobile: String,
                    birthdate: String,
                    fullname: String,
                    email: String,
                    pasword: String,
                    confirm: String,
                    userId: Int,
                    completion: @escaping (Bool)->()) {
         let id = userInfo[0].client_id!
         let url = "\(PublicData.baseUrl)/api/accounts/\(userId)"
         let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
         let header : HTTPHeaders =  ["Authorization" : token]

        
        tokenServices.checkExpirationDate(completion: {
            Alamofire.request(url,
                          method: .put,
                          parameters: [
                            "Id": userId,
                            "FullName": fullname,
                            "Birthday": birthdate,
                            "Gender": true,
                            "MobileNumber": mobile,
                            "EmailAddress": email
                          ],
                          encoding: JSONEncoding.default ,
                          headers: header).responseJSON(completionHandler: { response in
                
                            if response.response?.statusCode == 200 {
                                completion(true)
                            }
                            else {
                                completion(false)
                            }
                           
            })
        })
        
        
    }
}

