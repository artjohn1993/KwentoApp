//
//  VisitServices.swift
//  Kwento
//
//  Created by Art John on 16/12/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class VisitServices {
    let dataServices = CoreDataServices()
    var userInfo = [UserInfo]()
    let tokenService = TokenServices()
    
    func rate(parameter : Parameters, completion: @escaping (Bool)->()) {
        var url = "\(PublicData.baseUrl)/api/reviews"
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token, "Accept" : "application/json"]
        
        Alamofire.request(url,
                          method: .post,
                          parameters: parameter,
                          encoding: JSONEncoding.default,
                          headers: header).responseJSON(completionHandler: { response in
                            
                            if response.response?.statusCode == 200 {
                                PublicData.showSnackBar(message: "Thank You for the rating")
                                completion(true)
                            }
                            else {
                                completion(false)
                            }
                            
                          })
    }
    
    
}
