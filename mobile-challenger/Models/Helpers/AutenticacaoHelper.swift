//
//  AutenticacaoHelper.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 12/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit

import LocalAuthentication

class AutenticacaoHelper: NSObject {
    var error:NSError?
    
    func autorizaUsuario(completion:@escaping(_ autenticado:Bool)->Void){
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "É necessário autenticação para apagar este registro.") { (resposta, erro) in
                completion(resposta)
            }
        }
    }
    
}
