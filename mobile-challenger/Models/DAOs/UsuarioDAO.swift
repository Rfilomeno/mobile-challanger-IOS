//
//  UsuarioDAO.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 05/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit
import CoreData

class UsuarioDAO: NSObject {

    // MARK: - Variáveis
    
    var gerenciadorDeResultados:NSFetchedResultsController<UsuarioDataModel>?
    
    
    // MARK: - Contexto
    var contexto: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Funções
    func recuperaUsuarios() -> Array<UsuarioDataModel>{
        
        let pesquisaUsuario:NSFetchRequest<UsuarioDataModel> = UsuarioDataModel.fetchRequest()
        let ordenadorNome = NSSortDescriptor(key: "nome", ascending: true)
        pesquisaUsuario.sortDescriptors = [ordenadorNome]
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaUsuario, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try gerenciadorDeResultados?.performFetch()
        }catch{
            print(error.localizedDescription)
        }
        
        guard let listaDeUsuarios = gerenciadorDeResultados?.fetchedObjects else {return []}
        
        return listaDeUsuarios
        
    }
    
    func recuperaUsuario(id:Int)->UsuarioDataModel?{
        let usuarios = recuperaUsuarios()
        let usuarioRecuperado = usuarios.filter(){$0.id == id}.first
        return usuarioRecuperado
        
    }
    func recuperaUsuario(user:String)->UsuarioDataModel?{
        let usuarios = recuperaUsuarios()
        let usuarioRecuperado = usuarios.filter(){$0.user?.lowercased() == user.lowercased()}.first
        return usuarioRecuperado
        
    }
    
    func salvaUsuario(_ usuarioNaoSalvo:Usuario, lista:ListaRepositorio = []){
        var usuario:NSManagedObject?
        
        guard let id = usuarioNaoSalvo.id else {return}
        
        let usuarios = recuperaUsuarios().filter(){ $0.id == id}
        
        if usuarios.count > 0{
            guard let usuarioEncontrado = usuarios.first else {return}
            usuario = usuarioEncontrado
        }else{
            let entidade = NSEntityDescription.entity(forEntityName: "UsuarioDataModel", in: contexto)
            
            usuario = NSManagedObject(entity: entidade!, insertInto: contexto)
        }
        
        usuario?.setValue(id, forKey: "id")
        usuario?.setValue(usuarioNaoSalvo.user, forKey: "user")
        usuario?.setValue(usuarioNaoSalvo.nome, forKey: "nome")
        usuario?.setValue(usuarioNaoSalvo.numeroDeRepositoriosPublicos, forKey: "numeroRepositoriosPublicos")
        usuario?.setValue(usuarioNaoSalvo.seguidores, forKey: "seguidores")
        usuario?.setValue(usuarioNaoSalvo.seguindo, forKey: "seguindo")
        usuario?.setValue(usuarioNaoSalvo.urlDoUsuario, forKey: "urlDoUsuario")
        guard let urlAvatarUsuario = usuarioNaoSalvo.avatar else {return}
        guard let avatarUsuarioOP = try? Data(contentsOf: urlAvatarUsuario) else {return}
        guard let avatarimage = UIImage(data: avatarUsuarioOP) else {return}
        usuario?.setValue(avatarimage, forKey: "avatar")
        
        atualizaContexto()
        if lista.count > 0 {
            guard let id = usuarioNaoSalvo.id else {return}
            let usuarioOP = recuperaUsuario(id: id)
            guard let usuarioBusca = usuarioOP else {return}
            RepositorioDAO().salvarListaDeRepositorios(lista, usuario: usuarioBusca)
        }
    }
    
    
    
    func deletaUsuario(usuario:UsuarioDataModel){
        contexto.delete(usuario)
        atualizaContexto()
    }
    
    private func atualizaContexto(){
        do{
            try contexto.save()
            
        }catch{
            
            print(error.localizedDescription)
        }
    }
    
    
    
}
