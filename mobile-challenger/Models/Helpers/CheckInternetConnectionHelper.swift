//
//  CheckInternetConnectionHelper.swift
//  
//
//  Created by Rodrigo Filomeno on 03/06/19.
//

import UIKit
import Network

class CheckInternetConnectionHelper: NSObject {

    
    let monitor = NWPathMonitor()
    var haveConnection = false
    
    override init() {
        super.init()
        setup()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func setup(){
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.haveConnection = true
            } else {
                self.haveConnection = false
            }
        }
    }
    
    func checkInternet()->Bool{
        
        return self.haveConnection
    }
    
}
