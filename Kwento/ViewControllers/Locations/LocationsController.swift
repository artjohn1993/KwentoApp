//
//  LocationsController.swift
//  Kwento
//
//  Created by Richtone Hangad on 21/10/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class LocationsController: UIViewController {
    
    var service = AttractionServices()
    var totalLocationType: [JSON?] = []
    let dataServices = CoreDataServices()
    var arrayAttractionByCity = [AttractionByCity]()
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        checkAttraction(completion: { result in
            result ? self.loadLocalData(isFirstTime : false) : self.getAttraction()
        })
    }
    
    func getAttraction() {
        print("GET ATTRACTION...")
        service.getTotalLocationByType(type: "CityId", completion: { result in
             self.saveAttraction(data: result)
        })
    }
    
    func saveAttraction(data : [JSON?]) {
        print("SAVING ATTRACTION...")
        var index = 0
        data.forEach({ result in
            let attractionData = AttractionByCity(context: PersistenceService.context)
            print(result)
            attractionData.title = data[index]!["group"].string
            attractionData.total = String(data[index]!["number_of_items"].int ?? 0)
            attractionData.image = data[index]!["image_filename"].string
            
            
            if data[index]!["image_filename"].string != nil {
                print("image_filename is TRUE")
                self.checkImage(imageId: data[index]!["image_filename"].string!, completion: { (image, percent) in
                    print("\(percent)")
                    if percent == 1 {
                        self.table.reloadData()
                    }
                })
            }
            
        PersistenceService.saveContext()
        print("SAVE ITEM : \(data[index]!["group"].string)")
        index += 1
            
        })
        self.loadLocalData(isFirstTime : true)
    }
    
    func loadLocalData(isFirstTime : Bool) {
        print("LOAD LOCAL DATA...")
        dataServices.getAttractionByCity(completion: { result in
            print(result?.count)
            self.arrayAttractionByCity = result!
            self.table.reloadData()
        })
        
        if isFirstTime == false {
            dataServices.deleteData(entity: "AttractionByCity" , completion: {
                print("deleteAttractionBytity")
                self.getAttraction()
            })
        }
    }
    
    func checkImage(imageId : String, completion: @escaping (UIImage?,Float)->()) {
        var imageData = PublicData.getSavedImage(named: imageId)
        print("----------------------------->CHECK IMAGE")
        print(imageId)
        
        if imageData != nil {
            print("if")
            completion(imageData,1)
        }
        else {
            print("else")
            self.service.downloadImage(idImage: imageId, completion: { result in
                result == 1 ? completion(PublicData.getSavedImage(named: imageId), result) : completion(nil, result)
            })
        }
    }
    
    func checkAttraction(completion: @escaping(Bool)->()) {
         print("CHECKING ATTRACTION...")
        dataServices.getAttractionByCity(completion: { result in
            let dataResult = result ?? []
            dataResult.count > 0 ? completion(true) : completion(false)
        })
    }
    
    func setView() {
        self.table.register(AttractionViewCell.self, forCellReuseIdentifier: "attractionCell")
        self.table.rowHeight = UITableView.automaticDimension
        self.table.estimatedRowHeight = 150.0
        self.table.backgroundColor = UIColor.clear
        var edgeInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)

        self.table.contentInset = edgeInset
    }

}

extension LocationsController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayAttractionByCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "attractionCell") as! AttractionViewCell
          
        cell.title.text = self.arrayAttractionByCity[indexPath.row].title
          var total = self.arrayAttractionByCity[indexPath.row].total
          cell.attraction.text = "\(total!) Location"
          
          if self.arrayAttractionByCity[indexPath.row].image != nil {
              cell.background.image = PublicData.getSavedImage(named: self.arrayAttractionByCity[indexPath.row].image!)
          }
        
          cell.backgroundColor = UIColor.clear
          cell.selectionStyle = .none
//        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
}

