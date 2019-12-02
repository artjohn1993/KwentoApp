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
    
    
    func getAllAttraction() {
        print("PROCESS getAllAttraction...")
        var url = "\(PublicData.baseUrl)/api/attractions"
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        Alamofire.request(url,
                          method: .get,
                          headers: header).responseJSON(completionHandler: { result in
                            print("Success")
                            var response = result.result.value as? [[String:Any]]
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
            Alamofire.request(url,
                              method: .get,
                              headers: header).responseJSON(completionHandler: { response in
              print(response.result.value)
              print(response.response?.statusCode)
              guard let object = response.result.value else {
                  print("Error in getAttraction response")
                  return
              }
              let json = JSON(object)
              let jsonArray = json.array
              completion(jsonArray ?? [])
            })
        })
        
        
    }// end of getTotalLocationByType
    
    func getAttraction(completion: @escaping ([JSON?])->()) {
        print("getAttraction")
        var url = "\(PublicData.baseUrl)/api/attractionTypes"
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        tokenServices.checkExpirationDate(completion: {
            Alamofire.request(url,
                              method: .get,
                              headers: header
            ).responseJSON(completionHandler: { response in
                if response.response?.statusCode == 200 {
                    print(response.result.value)
                    print("checking getAttraction status:\(response.response?.statusCode)")
                    guard let object = response.result.value else {
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
    
    func getAttractionById(id: String, completion: @escaping (Float)->()) {
        print("PROCESS getAttractionById....")
        var url = "\(PublicData.baseUrl)/api/attractions/\(id)"
        dataServices.getUserInfo(completion: { result in
            self.userInfo = result!
        })
        let token = "\(userInfo[0].token_type!) \(userInfo[0].access_token!)"
        let header : HTTPHeaders =  ["Authorization" : token]
        
        tokenServices.checkExpirationDate(completion: {
            Alamofire.request(url,
                                     method: .get,
                       headers: header).responseJSON(completionHandler: { response in
                           print(response.result.value)
                           let data = response.result.value as? [String:Any]
                           if response.response?.statusCode == 200 {
                               
                               
                               var attractionData = DownloadedAttractionDetails(context: PersistenceService.context)
                               
                               attractionData.attractionDescription = data?["description"] as? String
                               attractionData.attractionTypeId = data?["attraction_type_id"] as? String
                               attractionData.audioFilename = data?["audio_filename"] as? String
                               print(attractionData.audioFilename)
                               attractionData.cityId = data?["city_id"] as? Int16 ?? 0
                               attractionData.id = data?["id"] as? String
                               attractionData.imageFilename = data?["image_filename"] as? String
                               attractionData.latitude = data?["latitude"] as? Float ?? 0.0
                               attractionData.locationInfo = data?["location_info"] as? String
                               attractionData.longitude = data?["longitude"] as? Float ?? 0.0
                               attractionData.name = data?["name"] as? String
                               attractionData.qrCodeFilename = data?["qr_code_filename"] as? String

                               PersistenceService.saveContext()
                               completion(0.1)
                               downloadAudio(idAudio: attractionData.audioFilename!, idImage: attractionData.imageFilename!)
                           }
                           
                       })
        })
        
        func downloadAudio(idAudio : String, idImage: String) {
            print("DOWNLOADING....")
            
            var url = "\(PublicData.baseUrl)/api/files/Audio/\(idAudio)/download"
            print(url)
            let fileUrl = getSaveFileUrl(fileName: "\(idAudio).mp3")
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            tokenServices.checkExpirationDate(completion: {
                Alamofire.download(url,
                                   method: .get,
                                   headers: header,
                                   to: destination).downloadProgress { (progress) in
                                    print(progress.fractionCompleted)
                                    completion(Float(progress.fractionCompleted * 0.8) + 0.1)
                }.responseData { (response) in
                    if response.response?.statusCode == 200 {
                        print("complete download Audio")
                        print("filename:\(idAudio)")
                        
                        let filesURL = response.destinationURL?.absoluteString
                        print("localpath: \(filesURL)")
                        downloadPicture(idImage: idImage, audioLink: filesURL!)
                    }
                    else {
                        print(response.response?.statusCode)
                    }
                }
            })
        }
        
        func downloadPicture(idImage: String, audioLink: String) {
            print("Downloading Image..")
            var url = "\(PublicData.baseUrl)/api/files/CoverImage/\(idImage)/download"
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                documentsURL.appendPathComponent("\(idImage).png")
                return (documentsURL, [.removePreviousFile])
            }
            
            tokenServices.checkExpirationDate(completion: {
                Alamofire.download(url,
                                   method: .get,
                                   headers: header,
                                   to: destination).downloadProgress { (progress) in
                                    print("image download:\(progress.fractionCompleted)")
                                    completion(Float((progress.fractionCompleted * 0.1) + 0.89))
                }.responseData(completionHandler: { (response) in
                    if response.destinationURL != nil {
                        print("complete download Image")
                        print(response.destinationURL ?? "")
                        let files = DownloadedFiles(context: PersistenceService.context)

                        files.image = response.destinationURL?.absoluteString
                        files.audio = audioLink
                        PersistenceService.saveContext()
                        completion(1)
                    }
                })
            })
            
        }
        
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
        

        Alamofire.download(url,
                           method: .get,
                           headers: header,
                           to: destination).downloadProgress { (progress) in
                            print("image download:\(progress.fractionCompleted)")
                            completion(Float(progress.fractionCompleted))
        }.responseData(completionHandler: { (response) in
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
        
        
            Alamofire.download(url,
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
    
    func getSaveFileUrl(fileName: String) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let nameUrl = URL(string: fileName)
        let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent)!)
        NSLog(fileURL.absoluteString)
        return fileURL;
    }
    
}
