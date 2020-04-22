//
//  LoginServices.swift
//  Kwento
//
//  Created by Art John on 15/11/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class LoginServices {
    
    let dataServices = CoreDataServices()
    var userInfo = [UserInfo]()
    
    func checkExternalId(id: String, completion : @escaping (Int)->()) {
        let url = "\(PublicData.baseUrl)/api/accounts/externalid/\(id)/exists"
        Alamofire.request(url,
                          method: .get).responseJSON(completionHandler: { (response) in
                            
                            print(response.response?.statusCode)
                            completion(response.result.value as! Int)
                          })
    }

    func login(username : String,password : String,provider : String, completion: @escaping (Bool)->()) {
        print("login")
        print(username)
        print(password)
        print(provider)
        let url = "\(PublicData.baseUrl)/api/account/login"
           
        let parameters: Parameters = [
               "client_id" : PublicData.clientId,
               "client_secret" : PublicData.client_secret,
               "grant_type" : "password",
               "username" : username,
               "password" : password,
               "provider" : provider
           ]
        print("parameter")
        print(parameters)
           //- send login request
           Alamofire.request(url,
                             method: .post,
                             parameters: parameters).responseJSON(completionHandler: { (response) in
                                let data = response.result.value as? [String:Any]
                                if response.response?.statusCode == 200 {
                                    if ((data?["access_token"]! as? String) != nil){
                                        var userInfo = UserInfo(context: PersistenceService.context)
                                        userInfo.access_token = data?["access_token"] as? String
                                        userInfo.token_type = data?["token_type"] as? String
                                        userInfo.expires_in = data?["expires_in"] as? String
                                        userInfo.refresh_token = data?["refresh_token"] as? String
                                        userInfo.client_id = data?["as:client_id"] as? String
                                        userInfo.userName = data?["userName"] as? String
                                        userInfo.issued = data?[".issued"] as? String
                                        userInfo.expires = data?[".expires"] as? String
                                        userInfo.password = password
                                        PersistenceService.saveContext()
                                        print(data)
                                    }
                                    completion(true)
                                }
                                else if response.response?.statusCode == 400 {
                                    completion(false)
                                    let message = response.result.value as? [String:Any]
                                    if message?["error_description"] as? String != nil {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 , execute: {
                                            PublicData.showSnackBar(message: message?["error_description"] as! String)
                                        })
                                    }
                                }
                                else {
     
                                    completion(false)
                                }
                               
               })
       }//- end of login function
    
    func signUp(fullname: String,
                birthday: String,
                gender: String,
                password: String,
                confirmPassword: String,
                phoneNumber: String,
                email: String,
                provider :String,
                externalId : String,
                token : String,
                completion : @escaping (Bool, String)->()
                ) {
        let userGender = gender == "Male" ? true : false
        
        let url = "\(PublicData.baseUrl)/api/accounts/register"
        let parameters: Parameters = [
        "full_name": fullname,
        "birthday": birthday,
        "gender": userGender,
        "password": password,
        "confirm_password": confirmPassword,
        "phone_number": phoneNumber,
        "email": email,
        "provider": provider,
        "external_id": externalId]

        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default).responseJSON(completionHandler: { response in
                            let data = response.result.value as? [String:Any]
                            if response.response?.statusCode == 200 {
                                print("Registered Successfully")
                                
                                if provider == "local" {
                                    self.login(username: email, password: password,provider: provider, completion: { isLoginSuccess in
                                        isLoginSuccess ? completion(true, "success") : completion(false,"")
                                    })
                                }
                                else if provider == "Facebook" || provider == "Google" {
                                    self.login(username: externalId, password: token,provider: provider, completion: { isLoginSuccess in
                                        isLoginSuccess ? completion(true, "success") : completion(false,"")
                                    })
                                }
                                
                            }
                            else {
                                print("failed signup service")
                                let data = response.result.value as? [String:Any]
                                let message = data?["Message"] as? String
                                print(message)
                                if message != nil {
                                    PublicData.showSnackBar(message: message!)
                                }
                                
                                completion(false,message ?? "")
                            }
                          })
    }//end of signUp function
    
    func verifyAccount( code : String,
                        completion : @escaping (Bool)->()) {
        let url = "\(PublicData.baseUrl)/api/accounts/verify/\(code)"
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        Alamofire.request(url,
                          method: .put,
            headers: header).responseJSON(completionHandler: { response in
                
                if response.response?.statusCode == 200 {
                    completion(true)
                }
                else {
                    print("ERROR")
                    print(response.result)
                    completion(false)
                }
            })
    }
    
    func forgetPassword(email : String,
                        completion : @escaping (Bool)->()){
        let url = "\(PublicData.baseUrl)/api/accounts/forgotPassword"
        let parameters: Parameters = ["email_address": email]
        
        Alamofire.request(url,
                          method: .get,
            parameters: parameters).responseJSON(completionHandler: { response in
                print(response.response?.statusCode)

                if response.response?.statusCode == 200 {
                    completion(true)
                }
                    
                else {
                    let data = response.result.value as? [String:Any]
                    let message = data?["Message"] as? String
                    print(message)
                    if message != nil {
                        PublicData.showSnackBar(message: message!)
                    }
                    
                    completion(false)
                }
            })
    }
}
