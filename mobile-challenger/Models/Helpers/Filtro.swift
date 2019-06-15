//
//  Filtro.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 02/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit

class Filtro: NSObject {

    
    func filtraRepositorios(listaDeRepositorio:Array<Repositorio>, nomeDoRepositorio:String) -> Array<Repositorio>{
        let repositoriosEncontrados = listaDeRepositorio.filter { (repositorio) -> Bool in
            
            if let nome = repositorio.nomeDoRepositorio {
                return nome.lowercased().contains(nomeDoRepositorio.lowercased())
            }
            return false
        }
        
        
        return repositoriosEncontrados
    }
    
    func filtraUsuarios(listaDeUsuario:Array<UsuarioDataModel>, nomeDoUsuario:String) -> Array<UsuarioDataModel>{
        let usuariosEncontrados = listaDeUsuario.filter { (usuario) -> Bool in
            
            if let nome = usuario.nome {
                return nome.lowercased().contains(nomeDoUsuario.lowercased())
            }
            return false
        }
        
        
        return usuariosEncontrados
    }
    
}
