//
//  CoreDataServices.swift
//  Kwento
//
//  Created by Art John on 19/11/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataServices {
    
    func getUserInfo(completion: @escaping ([UserInfo]?)->()) {
        var userInfo: [UserInfo] = [UserInfo]()
        let fetch: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        do {
            let info = try PersistenceService.context.fetch(fetch)
            userInfo = info
            completion(userInfo)
        }catch {
            completion(nil)
        }
    }
    
    func getDownloadedAttraction(completion: @escaping ([DownloadedAttractionDetails]?)->()) {
        print("fetching data from getDownloadedAttraction")
        var data: [DownloadedAttractionDetails] = [DownloadedAttractionDetails]()
        let fetch: NSFetchRequest<DownloadedAttractionDetails> = DownloadedAttractionDetails.fetchRequest()
        do {
            let info = try PersistenceService.context.fetch(fetch)
            data = info
            completion(data)
        }catch {
            completion(nil)
        }
    }
    
    func getDownloadedFiles(completion: @escaping ([DownloadedFiles]?)->()) {
        print("fetching data from getDownloadedFiles")
        var data: [DownloadedFiles] = [DownloadedFiles]()
        let fetch: NSFetchRequest<DownloadedFiles> = DownloadedFiles.fetchRequest()
        do {
            let info = try PersistenceService.context.fetch(fetch)
            data = info
            completion(data)
        }catch {
            completion(nil)
        }
    }
    
    func getAttractionByType(completion: @escaping ([AttractionByType]?)->()) {
        print("fetching data from getAttractionByType")
        var data: [AttractionByType] = [AttractionByType]()
        let fetch: NSFetchRequest<AttractionByType> = AttractionByType.fetchRequest()
        do {
            let info = try PersistenceService.context.fetch(fetch)
            data = info
            completion(data)
        }catch {
            completion(nil)
        }
    }
    
    func getAttractionByCity(completion: @escaping ([AttractionByCity]?)->()) {
        print("fetching data from getAttractionByCity")
        var data: [AttractionByCity] = [AttractionByCity]()
        let fetch: NSFetchRequest<AttractionByCity> = AttractionByCity.fetchRequest()
        do {
            let info = try PersistenceService.context.fetch(fetch)
            data = info
            completion(data)
        }catch {
            completion(nil)
        }
    }
    
    func getAllAttraction(completion: @escaping ([AllAttraction]?)->()) {
        print("fetching data from getAllAttraction")
        var data: [AllAttraction] = [AllAttraction]()
        let fetch: NSFetchRequest<AllAttraction> = AllAttraction.fetchRequest()
        do {
            let info = try PersistenceService.context.fetch(fetch)
            data = info
            completion(data)
        }catch {
            completion(nil)
        }
    }
    
    func getSession(completion: @escaping ([SessionData]?)->()) {
        print("fetching data from getAllAttraction")
        var data: [SessionData] = [SessionData]()
        let fetch: NSFetchRequest<SessionData> = SessionData.fetchRequest()
        do {
            let info = try PersistenceService.context.fetch(fetch)
            data = info
            completion(data)
        }catch {
            completion(nil)
        }
    }
    
    func getActiveSession(completion: @escaping ([ActiveSession]?)->()) {
        var data: [ActiveSession] = [ActiveSession]()
        let fetch: NSFetchRequest<ActiveSession> = ActiveSession.fetchRequest()
        do {
            let info = try PersistenceService.context.fetch(fetch)
            data = info
            completion(data)
        }catch {
            completion(nil)
        }
    }
    
    func saveActiveSession(id: String) {
        var session = ActiveSession(context: PersistenceService.context)
        session.id = id
        PersistenceService.saveContext()
    }
    
    func deleteData(entity : String, completion: @escaping ()->()) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: entity))
        do {
            try managedContext.execute(DelAllReqVar)
            completion()
        }
        catch {
            print(error)
        }
    }
    
}
