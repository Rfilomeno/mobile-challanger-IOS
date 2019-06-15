//
//  DataFormatHelper.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 01/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit

class DataFormatHelper: NSObject {

    
    func formata(_ dataOriginal:String) -> String{
        let dataTruncada = String(dataOriginal.prefix(10))
        let data = dataTruncada.split(separator: "-", maxSplits: 2, omittingEmptySubsequences: true)
        if data.count == 3{
            return "\(data[2])/\(data[1])/\(data[0])"
        }else{
            return ""
        }
        
    }
    
}
