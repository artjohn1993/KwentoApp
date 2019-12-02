//
//  LoginServices.swift
//  Kwento
//
//  Created by Art John on 15/11/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import Alamofire


class LoginServices {
    

    func login(username : String,password : String, completion: @escaping (Bool)->()) {

        let url = "\(PublicData.baseUrl)/api/account/login"
           
        let parameters: Parameters = [
               "client_id" : PublicData.clientId,
               "client_secret" : PublicData.client_secret,
               "grant_type" : "password",
               "username" : username,
               "password" : password,
               "provider" : "local"
           ]
        
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
                                else {
                                    print(response.result.value)
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
                completion : @escaping (Bool, String)->()
                ) {
        
        let url = "\(PublicData.baseUrl)/api/accounts/register"
        let parameters: Parameters = [
        "FullName": fullname,
        "Birthday": birthday,
        "Gender": true,
        "Password": password,
        "ConfirmPassword": confirmPassword,
        "PhoneNumber": phoneNumber,
        "Email": email,
        "Provider": "local",
        "ExternalId": "1234"]
        
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters).responseJSON(completionHandler: { response in
                            let data = response.result.value as? [String:Any]
                            if response.response?.statusCode == 200 {
                                self.login(username: email, password: password, completion: { isLoginSuccess in
                                    isLoginSuccess ? completion(true, "success") : completion(false,"")
                                })
                            }
                            else {
                                print("failed signup service")
                                print(response.result)
                                let data = response.result.value as? [String:Any]
                                let message = data?["Message"] as? String
                                print(message)
                                completion(false,message ?? "")
                            }
                          })
    }//end of signUp function
}
