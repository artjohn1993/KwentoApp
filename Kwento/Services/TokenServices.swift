//
//  TokenServices.swift
//  Kwento
//
//  Created by Art John on 29/11/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class TokenServices {
    
    let dataServices = CoreDataServices()
    
    func refreshToken(completion : @escaping ()->()) {
        print("REFRESH TOKEN...")
        var userInfo = [UserInfo]()
        let url = "\(PublicData.baseUrl)/api/account/login"
            
        dataServices.getUserInfo(completion: { result in
            userInfo = result ?? []
        })
        
        let parameters: Parameters = [
            "client_id" : PublicData.clientId,
            "client_secret" : PublicData.client_secret,
            "grant_type" : "refresh_token",
            "username" : userInfo[0].userName!,
            "password" : userInfo[0].password!,
            "provider" : "local",
            "refresh_token" : userInfo[0].refresh_token!
        ]

        
        //- send login request
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters).responseJSON(completionHandler: { (response) in
                            print(response.response?.statusCode)
                            
                          let data = response.result.value as? [String:Any]
                            if response.response?.statusCode == 200 {
                                
                                var user = userInfo.first
                                
                                 user?.access_token = data?["access_token"] as? String
                                 user?.token_type = data?["token_type"] as? String
                                 user?.expires_in = data?["expires_in"] as? String
                                 user?.refresh_token = data?["refresh_token"] as? String
                                 user?.client_id = data?["as:client_id"] as? String
                                 user?.userName = data?["userName"] as? String
                                 user?.issued = data?[".issued"] as? String
                                 user?.expires = data?[".expires"] as? String
                                
                                 PersistenceService.saveContext()
                            }
                        completion()
        })
    
    }
    
    func checkExpirationDate(completion : @escaping ()->()) {
        print("CHECK TOKEN...")
        var userInfo = [UserInfo]()
        let url = "\(PublicData.baseUrl)/api/account/login"
            
        dataServices.getUserInfo(completion: { result in
            userInfo = result ?? []
            if userInfo.count > 0 {
                print(userInfo[0].expires)
                let expiryDateTime = userInfo[0].expires
                let start = String.Index(encodedOffset: 0)
                let end = String.Index(encodedOffset: 16)
                let expiryDate = String(expiryDateTime?[start..<end] ?? "")
                let expiryHour = String(expiryDateTime?[String.Index(encodedOffset: 17)..<String.Index(encodedOffset: 19)] ?? "")
                let expiryMin = String(expiryDateTime?[String.Index(encodedOffset: 20)..<String.Index(encodedOffset: 22)] ?? "")
                
                self.getCurrentDate(completion: { (currentDate, currentTime) in
                    print("current:\(currentDate)")
                    print("expiryDate:\(expiryDate)")
                    if expiryDate == currentDate {
                        print("\(Int(String(currentTime[0]))!)>=\(Int(expiryHour)!)")
                        if Int(String(currentTime[0]))! >= Int(expiryHour)! {
                            print("if")
                            self.refreshToken(completion: {
                                completion()
                            })
                        }
                        else {
                            print("else")
                            completion()
                        }
                    }
                    else {
                        print("else in expiryDate == currentDate")
                        self.refreshToken(completion: {
                            completion()
                        })
                    }
                })
            }
        })
    }
    
    func getCurrentDate(completion: @escaping(_ currentDate: String, _ currentTime: [String.SubSequence])->()) {
        let date = Date()
        let formatter = DateFormatter()
        let formatter2 = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy"
        formatter2.dateFormat = "hh:mm:ss"
        
        let result = formatter.string(from: date)
        let result2 = formatter2.string(from: date)
        
        var time = result2.split(separator: ":")
        completion(result, time)
    }

}
