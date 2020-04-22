//
//  VisitsController.swift
//  Kwento
//
//  Created by Richtone Hangad on 10/10/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import FacebookShare
import FBSDKCoreKit

class VisitsController: UIViewController, SharingDelegate {
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        
    }
    
    
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
            if result != nil {
                self.visit = result?["rows"] as? [[String:Any]] ?? []
                self.visit.reverse()
                self.table.reloadData()
                PublicData.removeSpinnerAlert(controller: self)
            }
        })
    }
    
    @IBAction func didTapNavButton(_ sender: Any) {
        mainNavigationController.setDrawerState()
    }
    
    @IBAction func closeProfile(_ sender: Any) {
        mainNavigationController.popViewController(animated: true)
        SelectedNav.item = .dashboard
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
        //print(visit[indexPath.row]["end_date"] as? String)
        
        let url = URL(string: "https://install.appcenter.ms/orgs/kwento/apps/kwentoapp/distribution_groups/kwento%20distribution")
        let content = ShareLinkContent()
        content.contentURL = url!
        var attractionName = attraction?["name"]! as? String
        content.quote = """
        I just enjoyed a free audio tour in \(attractionName!) using the KwentoApp! Download now!\n\n
        For IOS: https://install.appcenter.ms/orgs/kwento/apps/kwentoapp/distribution_groups/kwento%20distribution\n
        For Android: https://appcenter.ms/orgs/Kwento/apps/Kwento/distribute/releases/8
        """
        
        let shareButton = FBShareButton()
        shareButton.shareContent = content
        
        
        
        cell.contentView.addSubview(shareButton)
        shareButton.center = cell.container.center
    
        
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

    
