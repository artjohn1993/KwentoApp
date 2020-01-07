//
//  VisitsController.swift
//  Kwento
//
//  Created by Richtone Hangad on 10/10/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit

class VisitsController: UIViewController {
    
    @IBOutlet weak var navButton: UIImageView!
    let sessionService = SessionServices()
    
    var visit = [[String:Any]]()
    var index = 0
    
    @IBOutlet weak var table: UITableView!
    var mainNavigationController: MainNavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Visit Controller")
        PublicData.spinnerAlert(controller: self)
        initViews()
        mainNavigationController = navigationController as? MainNavigationController
        sessionService.getUserSession(completion: { result in
            print("after call")
            if result != nil {
                self.visit = result?["rows"] as? [[String:Any]] ?? []
                self.visit.reverse()
                print(self.visit.count)
                
                self.table.reloadData()
                PublicData.removeSpinnerAlert(controller: self)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "visitToRate" {
            if let destinationVC = segue.destination as? RatingController {
                destinationVC.index = self.index
                print("passing:\(self.index)")
            }
        }
    }
    
    @IBAction func didTapNavButton(_ sender: Any) {
        mainNavigationController.setDrawerState()
    }
    
    @IBAction func closeProfile(_ sender: Any) {
        mainNavigationController.popViewController(animated: true)
    }
    
    private func initViews() {
        navButton.image = #imageLiteral(resourceName: "nav_button")
    }
    
    func timeAgo(time:String) -> String {
        var timeAgo = ""
        let year = String(time[String.Index(encodedOffset: 0)..<String.Index(encodedOffset: 4)])
        let months = String(time[String.Index(encodedOffset: 5)..<String.Index(encodedOffset: 7)])
        let days = String(time[String.Index(encodedOffset: 8)..<String.Index(encodedOffset: 10)])
        let hour = String(time[String.Index(encodedOffset: 11)..<String.Index(encodedOffset: 13)])
        let minutes = String(time[String.Index(encodedOffset: 14)..<String.Index(encodedOffset: 16)])
        let sec = String(time[String.Index(encodedOffset: 17)..<String.Index(encodedOffset: 19)])
        
        let date = Date()// Aug 25, 2017, 11:55 AM
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: date)
        let currentMonths = calendar.component(.month, from: date)
        let currentDay = calendar.component(.day, from: date)
        let currentHour = calendar.component(.hour, from: date)
        let currentMin = calendar.component(.minute, from: date)
        let currentSec = calendar.component(.second, from: date)
        
        if Int(year) == Int(currentYear) {
            if Int(months) == Int(currentMonths) {
                if Int(days) == Int(currentDay) {
                    if (Int(hour)! + 8) == Int(currentHour) {
                        if Int(minutes) == Int(currentMin) {
                            if Int(sec) == Int(currentSec) {
                                timeAgo = "just now"
                            }
                            else {
                                timeAgo = "\(Int(currentSec) - Int(sec)!) sec ago"
                            }
                        }
                        else {
                            timeAgo = "\(Int(currentMin) - Int(minutes)!) min ago"
                        }
                    }
                    else {
                        print("\(Int(currentHour)) - \((Int(hour)! + 8)) = \((Int(currentHour) - (Int(hour)! + 8)))")
                        timeAgo = "\(Int(currentHour) - (Int(hour)! + 8)) hour ago"
                    }
                }
                else {
                    timeAgo = "\(Int(currentDay) - Int(days)!) day ago"
                }
            }
            else {
                timeAgo = "\(Int(currentMonths) - Int(months)!) months ago"
            }
        }
        else {
            
            timeAgo = "\(Int(currentYear) - Int(year)!) year ago"
        }
        
        return timeAgo
    }

}

extension VisitsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visit.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VisitCell.self), for: indexPath) as! VisitCell
        let attraction = visit[indexPath.row]["attraction"] as? [String:Any]
        cell.attractionNameLabel.text = attraction?["name"] as? String
        cell.timeStampLabel.text = timeAgo(time: visit[indexPath.row]["end_date"] as! String)
        print(visit[indexPath.row])
        cell.reviewButton.addAction {
            print("adasda")
            self.index = indexPath.row
            self.performSegue(withIdentifier: "visitToRate", sender: nil)
            print("click in index :\(indexPath.row)")
        }
        //print(visit[indexPath.row]["end_date"] as? String)
        return cell
    }
}

class ClosureSleeve {
  let closure: () -> ()

  init(attachTo: AnyObject, closure: @escaping () -> ()) {
    self.closure = closure
    objc_setAssociatedObject(attachTo, "[\(arc4random())]", self,.OBJC_ASSOCIATION_RETAIN)
}

@objc func invoke() {
   closure()
 }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .primaryActionTriggered, action: @escaping () -> ()) {
  let sleeve = ClosureSleeve(attachTo: self, closure: action)
 addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
 }
}

    
