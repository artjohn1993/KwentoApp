//
//  AttractionServices.swift
//  Kwento
//
//  Created by Art John on 21/11/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON


class AttractionServices {
    let dataServices = CoreDataServices()
    var userInfo = [UserInfo]()
    var tokenServices = TokenServices()
    var request: Alamofire.Request?
    
    func getAllAttraction() {
        print("PROCESS getAllAttraction...")
        var url = "\(PublicData.baseUrl)/api/attractions"
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        self.request = Alamofire.request(url,
                          method: .get,
                          headers: header).responseJSON(completionHandler: { result in
                            print("Success")
                            let row = result.result.value as? [String:Any]
                            var response = row?["rows"] as? [[String:Any]]
                            response?.forEach({ item in
                                var item2 = item as? [String:Any]
                                var allAttraction = AllAttraction(context: PersistenceService.context)
                                allAttraction.id = String(item2?["id"] as! Int)
                                allAttraction.attraction_type_id = String(item2?["attraction_type_id"] as! Int)
                                allAttraction.name = item2?["name"] as? String
                                allAttraction.city_id = String(item2?["city_id"] as! Int)
                                allAttraction.latitude = String(item2?["latitude"] as! Double)
                                allAttraction.longitude = String(item2?["longitude"] as! Double)
                                allAttraction.location_info = item2?["location_info"] as? String
                                allAttraction.descriptions = item2?["description"] as? String
                                allAttraction.image_filename = item2?["image_filename"] as? String
                                allAttraction.audio_filename = item2?["audio_filename"] as? String
                                var sub = item2?["sub_attractions"] as? [[String:Any]]
                                allAttraction.sub_attractions = (sub?.count ?? 0 > 0) ? true : false
                                
                                self.downloadAudio(idAudio: allAttraction.audio_filename ?? "", completion: { result in
                                    print("audio:\(result)")
                                })
                                
                                self.downloadImage(idImage: allAttraction.image_filename ?? "", completion: { result in
                                      print("image:\(result)")
                                })
                                
                                PersistenceService.saveContext()
                                print("SAVE : \(item2?["name"] as! String)")
                            })
            })
    }
    
    func getTotalLocationByType(type: String, completion: @escaping ([JSON?])->()) {    
        var url = "\(PublicData.baseUrl)/api/attractions/\(type)/summary"
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        tokenServices.checkExpirationDate(completion: {
            self.request = Alamofire.request(url,
                              method: .get,
                              headers: header).responseJSON(completionHandler: { response in
              print(response.result.value)
              print(response.response?.statusCode)
              let row = response.result.value as? [String:Any]
              guard let object = row?["rows"] else {
                  print("Error in getAttraction response")
                  return
              }
              let json = JSON(object)
              let jsonArray = json.array
              completion(jsonArray ?? [])
            })
        })
    }// end of getTotalLocationByType
    
    func getAttractions(type :String, id : Int, completion : @escaping ([String:Any]?)->()) {
         var url = "\(PublicData.baseUrl)/api/attractions?\(type)=\(id)"
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        Alamofire.request(url,
                          method: .get,
                          headers: header).responseJSON(completionHandler: { response in
                          
                            if response.response?.statusCode == 200 {
                                let result = response.result.value as? [String:Any]
                                completion(result)
                            }
                            else {
                                completion(nil)
                            }
            })
    }
    
    func getAttraction(completion: @escaping ([JSON?])->()) {
        print("getAttraction")
        var url = "\(PublicData.baseUrl)/api/attractionTypes"
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        tokenServices.checkExpirationDate(completion: {
            self.request = Alamofire.request(url,
                              method: .get,
                              headers: header
            ).responseJSON(completionHandler: { response in
                if response.response?.statusCode == 200 {
                    print(response.result.value)
                    print("checking getAttraction status:\(response.response?.statusCode)")
                    let row = response.result.value as? [String:Any]
                    guard let object = row?["row"] else {
                        print("Error in getAttraction response")
                        return
                    }
                    let json = JSON(object)
                    let jsonArray = json.array
                    completion(jsonArray ?? [])
                }
                
                else if response.response?.statusCode == 401 {
                   let message = response.result.value as? [String:Any]
                   print(message?["Message"] as? String)
                    if message?["Message"] as? String == "Authorization has been denied for this request." {
                        print("token need to refresh")
                    }
                    
                   completion([])
                }
                
            })
        })
        
        
    }// end of getAttraction
    
    func getAttractionById(id: String, completion: @escaping ([String:Any]?)->()) {
        print("PROCESS getAttractionById....")
        var url = "\(PublicData.baseUrl)/api/attractions/\(id)"
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        
        self.request = Alamofire.request(url,
                              method: .get,
                              headers: header).responseJSON(completionHandler: { response in
                                print(response.result.value)
                                let data = response.result.value as? [String:Any]
                                if response.response?.statusCode == 200 {
                                    completion(data ?? nil)
                                }
                                else if response.response?.statusCode == 401 {
                                    self.tokenServices.refreshToken {
                                        self.getAttractionById(id: id, completion: { response in
                                            completion(data ?? nil)
                                            print("getAttractionById second call after refresh")
                                        })
                                    }
                                }
                                else {
                                    var error = response.result.value as? [String:Any]
                                    
                                    print(error?["Message"] as? String)
                                    print(response.response?.statusCode)
                                    
                                }
                           
                       })

        
    }// end of getAttractionById
    
    func downloadImage(idImage: String, completion : @escaping (Float)->()) {
        print("Downloading Image..")
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        var url = "\(PublicData.baseUrl)/api/files/CoverImage/\(idImage)/download"
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent("\(idImage).png")
            return (documentsURL, [.removePreviousFile])
        }
        

        self.request = Alamofire.download(url,
                           method: .get,
                           headers: header,
                           to: destination).downloadProgress { (progress) in
                            print("image download:\(progress.fractionCompleted)")
                            completion(Float(progress.fractionCompleted))
        }.responseData(completionHandler: { (response) in
            print(response.response?.statusCode)
            if response.destinationURL != nil {
                print("complete download Image")
                print(response.destinationURL ?? "")
            }
        })
    }
    
    func downloadAudio(idAudio : String, completion : @escaping (Float)->()) {
        print("Downloading Audio..")
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        var url = "\(PublicData.baseUrl)/api/files/Audio/\(idAudio)/download"
        print(url)
        let fileUrl = getSaveFileUrl(fileName: "\(idAudio).mp3")
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        
        self.request = Alamofire.download(url,
                               method: .get,
                               headers: header,
                               to: destination).downloadProgress { (progress) in
                                print(progress.fractionCompleted)
                                completion(Float(progress.fractionCompleted))
            }.responseData { (response) in
                if response.response?.statusCode == 200 {
                    print("complete download Audio")
                }
                else {
                    print(response.response?.statusCode)
                }
            }
    }
    
    func stream(id : String, completion: @escaping (Data)->()) {
        print("Streaming Audio..")
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        var url = "\(PublicData.baseUrl)/api/files/audio/\(id)/stream"
        print(url)
        Alamofire.request(url).stream(closure: { (data) in
                
                print("result in streaming")
                print(data)
                completion(data)
            }).responseJSON(completionHandler: { response in
                print(response.response?.statusCode)
                print(response.result.value)
            })
    }
    
    func getSaveFileUrl(fileName: String) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let nameUrl = URL(string: fileName)
        let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent)!)
        NSLog(fileURL.absoluteString)
        return fileURL;
    }
    
}
