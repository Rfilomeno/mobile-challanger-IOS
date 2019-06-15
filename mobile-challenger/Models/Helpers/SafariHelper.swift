//
//  SafariHelper.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 01/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit
import SafariServices

class SafariHelper: NSObject {
    
    var controller:UIViewController
    
    init(controller:UIViewController) {
        self.controller = controller
    }

    func abrirNoSafari(URL:URL?){
        
        guard let url = URL else {
            AlertDialogHelper(controller: controller).show("Desculpe", message: "Não foi possível abrir a pagina solicitada")
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        controller.present(safariViewController,animated: true,completion: nil)
    }
    
}
