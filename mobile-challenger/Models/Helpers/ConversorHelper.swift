//
//  ConversorHelper.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 05/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit

class ConversorHelper: NSObject {

    func converteUsuario(_ usuarioDataModel:UsuarioDataModel)->Usuario{
        var usuario = Usuario()
        usuario.id = Int(usuarioDataModel.id)
        usuario.user = usuarioDataModel.user
        usuario.nome = usuarioDataModel.nome
        usuario.avatarFoto = usuarioDataModel.avatar
        usuario.numeroDeRepositoriosPublicos = Int(usuarioDataModel.numeroRepositoriosPublicos)
        usuario.seguidores = Int(usuarioDataModel.seguidores)
        usuario.seguindo = Int(usuarioDataModel.seguindo)
        if let url = usuarioDataModel.urlDoUsuario {
            usuario.urlDoUsuario = url as! URL
        }
        
        usuario.avatar = nil
        
        return usuario
    }
    
    func converteRepositorio(_ repositorioDataModel:RepositorioDataModel)->Repositorio{
        var repositorio = Repositorio()
        
        repositorio.id = Int(repositorioDataModel.id)
        repositorio.nomeDoRepositorio = repositorioDataModel.nomeDoRepositorio
        repositorio.descricaoCompleta = repositorioDataModel.descricaoCompleta
        repositorio.numeroDeStars = Int(repositorioDataModel.numeroDeStars)
        repositorio.numeroDeForks = Int(repositorioDataModel.numeroDeForks)
        repositorio.numeroDeIssuesAbertas = Int(repositorioDataModel.numeroDeIssuesAbertas)
        repositorio.numeroDeIssuesFechadas = Int(repositorioDataModel.numeroDeIssuesFechadas)
        repositorio.dataDeCriacaoDoRepositorio = repositorioDataModel.dataDeCriacaoDoRepositorio
        repositorio.linguagem = repositorioDataModel.linguagem
        if let urlNSObject = repositorioDataModel.urlDoRepositorio{
            let url = urlNSObject as! URL
            repositorio.urlDoRepositorio = url
        }
        
        return repositorio
        
    }
    
    func converteListaRepositorio(_ listaRepositorioDataModel:Array<RepositorioDataModel>)->ListaRepositorio{
        var lista = ListaRepositorio()
        for repositorio in listaRepositorioDataModel{
            lista.append(converteRepositorio(repositorio))
        }
        return lista
    }
    
}
