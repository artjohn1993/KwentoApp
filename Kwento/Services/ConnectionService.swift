//
//  ConnectionService.swift
//  Kwento
//
//  Created by Art John on 09/12/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import Network

class ConnectionService {
    let monitor = NWPathMonitor()
    
    func checkConnection(completion: @escaping (Bool)->()) {
        var checker = false
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                completion(true)
                //PublicData.showSnackBar(message: "We're connected!")
            } else {
                print("No connection.")
                completion(false)
                //PublicData.showSnackBar(message: "No connection")
            }
        }
        
    }
    
}
