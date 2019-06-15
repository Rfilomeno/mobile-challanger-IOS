//
//  Configuracao.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 31/05/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit

class Configuracao: NSObject {
    
    lazy var caminhoParaPlist:String = {
        guard let caminhoParaPlist = Bundle.main.path(forResource: "Info", ofType: "plist") else {return ""}
        return caminhoParaPlist
    }()
    
    
    func getUrlGitHub()->String?{
        guard let dicionario = NSDictionary(contentsOfFile: caminhoParaPlist) else {return nil}
        guard let UrlGitHub = dicionario["UrlApiGitHub"] as? String else {return nil}
        return UrlGitHub
    }
}
