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
    
    var mainNavigationController: MainNavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        mainNavigationController = navigationController as? MainNavigationController
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

}

extension VisitsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VisitCell.self), for: indexPath) as! VisitCell
        
        return cell
    }
}
