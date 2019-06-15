//
//  Repositorio.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 31/05/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import Foundation

typealias ListaRepositorio = [Repositorio]
struct Repositorio: Codable {
    var id:Int?
    var nomeDoRepositorio:String?
    var descricaoCompleta: String?
    var numeroDeStars: Int?
    var numeroDeForks: Int?
    var numeroDeIssuesAbertas:Int?
    var numeroDeIssuesFechadas:Int? //API do Github não retorna issues fechadas
    var dataDeCriacaoDoRepositorio:String?
    var linguagem:String?
    var urlDoRepositorio:URL?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case nomeDoRepositorio = "name"
        case descricaoCompleta = "description"
        case numeroDeStars = "stargazers_count"
        case numeroDeForks = "forks"
        case numeroDeIssuesAbertas = "open_issues"
        case numeroDeIssuesFechadas = "open_issues_count" //API do Github não retorna issues fechadas
        case dataDeCriacaoDoRepositorio = "created_at"
        case linguagem = "language"
        case urlDoRepositorio = "html_url"
    }
    
    
}
