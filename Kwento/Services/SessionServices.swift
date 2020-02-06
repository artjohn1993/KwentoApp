//
//  SessionServices.swift
//  Kwento
//
//  Created by Art John on 02/12/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON

class SessionServices {
    let dataServices = CoreDataServices()
    var userInfo = [UserInfo]()
    let tokenService = TokenServices()
    
    func startSession(id: String, completion : @escaping ()->()) {
        print("startSession")
        var url = "\(PublicData.baseUrl)/api/sessions/\(id)/start"
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token, "Accept" : "application/json"]
        
        Alamofire.request(url,
                          method: .post,
                          headers: header).responseJSON(completionHandler: { response in
                            print(response.result.value)
                            let result = response.result.value as? [String:Any]
                            var sessionData = SessionData(context: PersistenceService.context)
                            sessionData.attraction = result?["attraction"] as? String
                            sessionData.attraction_id = String(result?["attraction_id"] as! Int)
                            sessionData.end_date = result?["end_date"] as? String
                            sessionData.id = String(result?["id"] as! Int)
                            sessionData.start_date = result?["start_date"] as? String
                            sessionData.user_id = String(result?["user_id"] as! Int)

                            print("session id: \(String(result?["id"] as! Int))")
                         
                            PersistenceService.saveContext()
                            completion()
            }) 
    }
    
    func endSession(sessionId : String) {
        print("endSession")
            
        print("session id from endSession: \(sessionId)")
        
        var url = "\(PublicData.baseUrl)/api/sessions/\(sessionId)/end"
        print(url)
        self.dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(self.userInfo[0].token_type!) \(self.userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        Alamofire.request(url,
                          method: .post,
                          headers: header).responseJSON(completionHandler: { response in
                            
                            print(response.result.value)
                            print(response.response?.statusCode)
                            if response.response?.statusCode == 200 {
                                print("success end")
                                
                                self.dataServices.deleteData(entity: "ActiveSession", completion: {})
                                
                                self.dataServices.getSession(completion: { response in
                                    var data = response?.first
                                    
                                    if data?.attraction_id != nil {
                                        self.getAttraction(id: (data?.attraction_id!)!)
                                    }
                                    
                                    self.dataServices.deleteData(entity: "SessionData", completion: {})
                                        
                                    
                                })
                            }
                          })
       
    }
    
    func getActiveSession(completion: @escaping ([String:Any]?)->()) {
        print("getActiveSession")
        var url = "\(PublicData.baseUrl)/api/sessions/user/active"
        self.dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(self.userInfo[0].token_type!) \(self.userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        Alamofire.request(url,
                          method: .get,
                          headers: header).responseJSON(completionHandler: { response in
                            print("response")
                            print(response.response?.statusCode)
                            if response.response?.statusCode == 200 {
                                let data = response.result.value as? [String:Any]
                                print(data)
                                completion(data)
                            }
                            else if response.response?.statusCode == 401 {
                               let msg = response.result.value as? [String:Any]
                                print(msg?["Message"] as? String)
                                if msg?["Message"] as? String == "Authorization has been denied for this request." {
                                    self.tokenService.refreshToken {
                                        self.getActiveSession(completion: { response2 in
                                            completion(response2)
                                        })
                                    }
                                }
                            }
                            else {
                                print("else")
                                print(response.result)
                                completion(nil)
                            }
        })
    }
    
    func getAttraction(id : String) {
        print("getAttraction")
        let service = AttractionServices()
        
        service.getAttractionById(id: id, completion: { response in
            var imageFile = response?["image_filename"] as? String
            self.deleteFile(fileName: "\(imageFile!).png")
            let subAttraction = response?["sub_attractions"] as? [[String: Any]]
            print(subAttraction)
            print(subAttraction?.count)
            if subAttraction?.count ?? 0 > 0 {
                subAttraction?.forEach({ item in
                    var data = item as? [String:Any]
                    var audioName = data?["audio_filename"] as? String
                    self.deleteFile(fileName: "\(audioName!).mp3")
                })
            }
            else {
                var audioFIle = response?["audio_filename"] as? String
                //self.deleteFile(fileName: "\(audioFIle!).mp3")
            }
        })
    }
    
    func deleteFile(fileName : String) {
        let fileNameToDelete = fileName
        var filePath = ""

        // Fine documents directory on device
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        filePath = documentDirectory.appendingFormat("/" + fileNameToDelete)

        do {
            let fileManager = FileManager.default

            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                print("Delete file")
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }

        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    
    func getUserSession(completion : @escaping ([String:Any]?)->()) {
        print("getUserSession")
        var url = "\(PublicData.baseUrl)/api/sessions/user?completed_only=true"
        print(url)
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        //let parameters: Parameters = ["completed_only" : true]
        
        Alamofire.request(url,
                          method: .get,
                          headers: header).responseJSON(completionHandler: { response in
                            
                            if response.response?.statusCode == 200 {
                                let result = response.result.value as? [String:Any]
                                print(result)
                                completion(result)
                            }
                            else if response.response?.statusCode == 401 {
                               let message = response.result.value as? [String:Any]
                               print(message?["Message"] as? String)
                                if message?["Message"] as? String == "Authorization has been denied for this request." {
                                    self.tokenService.refreshToken {
                                        self.getUserSession(completion: { result in
                                            completion(result)
                                        })
                                    }
                                }
                            }
                            else {
                                completion(nil)
                            }
            
            })
        
    }
    
}
