//
//  CategoriesController.swift
//  Kwento
//
//  Created by Richtone Hangad on 21/10/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import SwiftyJSON


class CategoriesController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var data: [JSON?] = []
    var totalLocationType: [JSON?] = []
    var service = AttractionServices()
    let dataServices = CoreDataServices()
    var arrayAttractionByType = [AttractionByType]()
    var id = 0
    let indicator = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        
        checkAttraction(completion: { result in
            result ? self.loadLocalData(isFirstTime : false) : self.firstCall()
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationToMuseum" {
            if let destinationVC = segue.destination as? MuseumController {
                destinationVC.id = self.id
                destinationVC.type = "queryParams.attraction_type_id"
            }
        }
        
    }
    
    func firstCall() {
        indicator.startAnimating()
        self.getAttraction()
    }
    
    func getAttraction() {
        print("GET ATTRACTION...")
        self.service.getTotalLocationByType(type : "AttractionTypeId", completion: { result in
            //self.totalLocationType = result
            //print("success call 2 \(self.totalLocationType.count)")
            self.saveAttraction(data: result)
            self.indicator.stopAnimating()
        })
        
    }
    
    func saveAttraction(data : [JSON?]) {
        print("SAVING ATTRACTION...")
        var index = 0
        data.forEach({ result in
            let attractionData = AttractionByType(context: PersistenceService.context)
            print(result)
            attractionData.title = data[index]!["group"].string
            attractionData.total = String(data[index]!["number_of_items"].int ?? 0)
            attractionData.image = data[index]!["image_filename"].string
            attractionData.id = String(data[index]!["group_id"].int ?? 0)
            
            
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
        dataServices.getAttractionByType(completion: { result in
            print(result?.count)
            self.arrayAttractionByType = result!
            self.table.reloadData()
        })
        
        if isFirstTime == false {
            dataServices.deleteData(entity: "AttractionByType" , completion: {
                print("deleteAttractionByType")
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
        dataServices.getAttractionByType(completion: { result in
            let dataResult = result ?? []
            dataResult.count > 0 ? completion(true) : completion(false)
        })
    }
    
    func setView() {
        self.table.register(AttractionViewCell.self, forCellReuseIdentifier: "attractionCell")
        self.table.rowHeight = UITableView.automaticDimension
        self.table.estimatedRowHeight = 150.0
        var edgeInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        self.table.contentInset = edgeInset
        
        indicator.center.x = (self.view.frame.width / 2) - 20
        var edgeInset2 = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        indicator.frame = indicator.frame.inset(by: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0))
        view.addSubview(indicator)
    }
}

extension CategoriesController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayAttractionByType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "attractionCell") as! AttractionViewCell
        cell.title.text = self.arrayAttractionByType[indexPath.row].title
        print(self.arrayAttractionByType[indexPath.row])
        var total = self.arrayAttractionByType[indexPath.row].total
        cell.attraction.text = "\(total!) Location"
        if self.arrayAttractionByType[indexPath.row].image != nil {
            cell.background.image = PublicData.getSavedImage(named: self.arrayAttractionByType[indexPath.row].image!)
        }

        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.layoutSubviews()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.id = Int(self.arrayAttractionByType[indexPath.row].id ?? "0")!
        print(self.id)
        //print(self.arrayAttractionByType[indexPath.row]itle)
        if self.arrayAttractionByType[indexPath.row].total != "0" {
            self.performSegue(withIdentifier: "locationToMuseum", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
}

