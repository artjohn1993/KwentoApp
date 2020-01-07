//
//  SuggestionServices.swift
//  Kwento
//
//  Created by Art John on 12/12/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class SuggestionServices {
    let dataServices = CoreDataServices()
    var userInfo = [UserInfo]()
    let tokenService = TokenServices()
   
    
    func suggest(userid: Int, message : String, completion: @escaping (Bool)->()) {
        print("suggest")
        var url = "\(PublicData.baseUrl)/api/suggestions"
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token, "Accept" : "application/json"]
        
        let parameters: Parameters = [
            "user_id" : userid,
            "message" : message
        ]
        
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: header).responseJSON(completionHandler: { response in
                            
                            print(response.response?.statusCode)
                            if response.response?.statusCode == 200 {
                                completion(true)
                            }
                            else if response.response?.statusCode == 401 {
                               let msg = response.result.value as? [String:Any]
                                print(msg?["Message"] as? String)
                                if msg?["Message"] as? String == "Authorization has been denied for this request." {
                                    self.tokenService.refreshToken {
                                        self.suggest(userid: userid, message: message, completion: { result in
                                            completion(result)
                                        })
                                    }
                                }
                            }
                            else {
                                completion(false)
                            }
            })
    }
    
}
