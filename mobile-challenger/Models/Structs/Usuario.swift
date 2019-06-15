//
//  Usuario.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 31/05/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import Foundation

struct Usuario: Codable {
    var id: Int?
    var user:String?
    var nome:String?
    var avatar: URL?
    var numeroDeRepositoriosPublicos:Int?
    var seguidores:Int? 
    var seguindo:Int?
    var urlDoUsuario:URL?
    var avatarFoto:NSObject?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case user = "login"
        case nome = "name"
        case avatar = "avatar_url"
        case numeroDeRepositoriosPublicos = "public_repos"
        case seguidores = "followers"
        case seguindo = "following"
        case urlDoUsuario = "html_url"
        
    }
    
    
}
