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
        print("getCurrentUser")
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        
        let id = userInfo[0].client_id
        let url = "\(PublicData.baseUrl)/api/accounts/current"
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        
        Alamofire.request(url,
                          method: .get,
                          headers: header).responseJSON(completionHandler: { response in
            let data = response.result.value as? [String:Any]
            print(response.result.value)
            print(response.response?.statusCode)
            if response.response?.statusCode == 200 {
                print("success")
                completion(data)
            }
            else if response.response?.statusCode == 401 {
               let msg = response.result.value as? [String:Any]
                print(msg?["Message"] as? String)
                if msg?["Message"] as? String == "Authorization has been denied for this request." {
                    self.tokenServices.refreshToken {
                        self.getCurrentUser(completion: { result in
                            completion(result)
                        })
                    }
                }
            }
            else {
                print("failed")
                print(response.error)
                print(response.data)
               completion(data)
            }
        })
    }// end of get current user function
    
    func updateInfo(mobile: String,
                    birthdate: String,
                    fullname: String,
                    email: String,
                    userId: Int,
                    completion: @escaping (Bool)->()) {
        self.dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        
         let id = userInfo[0].client_id!
         let url = "\(PublicData.baseUrl)/api/accounts/\(userId)"
         let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
         let header : HTTPHeaders =  ["Authorization" : token]

        
        tokenServices.checkExpirationDate(completion: {
            Alamofire.request(url,
                          method: .put,
                          parameters: [
                            "id": userId,
                            "full_name": fullname,
                            "birthday": birthdate,
                            "gender": true,
                            "phone_number": mobile,
                            "email_address": email
                          ],
                          encoding: JSONEncoding.default ,
                          headers: header).responseJSON(completionHandler: { response in
                            print(response.response?.statusCode)
                            print(response.result.value)
                            if response.response?.statusCode == 200 {
                                completion(true)
                            }
                            else {
                                completion(false)
                            }
            })
        })
    }
    
    func changePassword(newpass: String,
                        oldpass: String,
                        confirmpass: String,
                        completion: @escaping (Bool)->()) {
        print("changePassword")
        self.dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        let url = "\(PublicData.baseUrl)/api/accounts/changePassword"
        print(url)
        tokenServices.checkExpirationDate(completion: {
            Alamofire.request(url,
                              method: .post,
                              parameters: [
                                "old_password": oldpass,
                                "password": newpass,
                                "confirm_password": confirmpass],
                               encoding: JSONEncoding.default,
                               headers: header).responseJSON(completionHandler: { response in
                                
                                if response.response?.statusCode == 200 {
                                    completion(true)
                                }
                                else {
                                    completion(false)
                                    print(response.response)
                                    print(response.result.description)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 , execute: {
                                       PublicData.showSnackBar(message: "Invalid Password")
                                   })
                                }
                               })
        })
    }
    
    func logout(completion: @escaping ()->()) {
        dataServices.deleteData(entity: "SessionData", completion: {
            self.dataServices.deleteData(entity: "AllAttraction", completion: {
                self.dataServices.deleteData(entity: "AttractionByCity", completion: {
                    self.dataServices.deleteData(entity: "AttractionByType", completion: {
                        self.dataServices.deleteData(entity: "DownloadedFiles", completion: {
                            self.dataServices.deleteData(entity: "DownloadedAttractionDetails", completion: {
                                self.dataServices.deleteData(entity: "UserInfo", completion: {
                                    self.dataServices.deleteData(entity: "ActiveSession", completion: {
                                        completion()
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
    }
}

