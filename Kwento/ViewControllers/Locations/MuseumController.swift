//
//  MuseumController.swift
//  Kwento
//
//  Created by Art John on 16/12/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import UIKit

class MuseumController : UIViewController {
    
    @IBOutlet var table: UITableView!
    var id = 0
    var type = ""
    var data : [[String:Any]] = []
    let attractionService = AttractionServices()
    var mainNavigationController: MainNavigationController!
    var titleSelected : String = ""
    var imageSelected : String = ""
    var descriptionSelected : String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()

        mainNavigationController = navigationController as? MainNavigationController
        table.backgroundColor = UIColor.clear
        attractionService.getAttractions(type: type, id: id, completion: { result in
            print("getAttractions result")
            if result != nil {
                self.data = (result?["rows"] as? [[String:Any]])!
                self.table.reloadData()
            }
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoView" {
            if let destinationVC = segue.destination as? DetailsViewController {
                destinationVC.titleVal = self.titleSelected
                destinationVC.descriptionVal = self.descriptionSelected
                destinationVC.imageVal = self.imageSelected
            }
        }
    }
    
    @IBAction func tapNav(_ sender: Any) {
        mainNavigationController.setDrawerState()
    }
    @IBAction func close(_ sender: Any) {
        mainNavigationController.popViewController(animated: true)
    }
    
}

extension MuseumController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "museumViewCell") as! MuseumViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.attractionTitle.text = data[indexPath.row]["name"] as? String
        cell.attractionDescription.text = data[indexPath.row]["description"] as? String
        
        
        let imageName = data[indexPath.row]["image_filename"] as? String

        if imageName != nil {
            let image = PublicData.getSavedImage(named: "\(imageName!).png")
            if image == nil {
                print("if")
                attractionService.downloadImage(idImage: imageName!, completion: { result in
                    cell.indicator.startAnimating()
                    if Int(result) == 1 {
                        print("yehey humana")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                           cell.attractionImage.image = PublicData.getSavedImage(named: "\(imageName!).png")
                           cell.indicator.stopAnimating()
                           self.table.reloadData()
                        }

                    }

                })
            }
            else {
                print("else")
                cell.attractionImage.image = PublicData.getSavedImage(named: "\(imageName!).png")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.titleSelected = data[indexPath.row]["name"] as? String ?? ""
        self.descriptionSelected = data[indexPath.row]["description"] as? String ?? ""
        self.imageSelected = data[indexPath.row]["image_filename"] as? String ?? ""
        
        self.performSegue(withIdentifier: "gotoView", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
}
