//
//  RepositorioDAO.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 05/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit
import CoreData

class RepositorioDAO: NSObject {
    // MARK: - Variáveis
    var gerenciadorDeResultados:NSFetchedResultsController<RepositorioDataModel>?
    
    // MARK: - Contexto
    var contexto: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Funções
    
    func recuperaRepositorios() -> Array<RepositorioDataModel>{
        
        let pesquisaRepositorio:NSFetchRequest<RepositorioDataModel> = RepositorioDataModel.fetchRequest()
        let ordenadorNome = NSSortDescriptor(key: "nomeDoRepositorio", ascending: true)
        pesquisaRepositorio.sortDescriptors = [ordenadorNome]
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaRepositorio, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try gerenciadorDeResultados?.performFetch()
        }catch{
            print(error.localizedDescription)
        }
        
        guard let listaDeRepositorios = gerenciadorDeResultados?.fetchedObjects else {return []}
        
        return listaDeRepositorios
        
    }
    
    func recuperaRepositoriosDoUsuario(usuario:UsuarioDataModel) -> Array<RepositorioDataModel>{
        
        let pesquisaRepositorio:NSFetchRequest<RepositorioDataModel> = RepositorioDataModel.fetchRequest()
        
        let ordenadorNome = NSSortDescriptor(key: "numeroDeStars", ascending: true)
        pesquisaRepositorio.sortDescriptors = [ordenadorNome]
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaRepositorio, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try gerenciadorDeResultados?.performFetch()
        }catch{
            print(error.localizedDescription)
        }
        
        guard let listaDeRepositorios = gerenciadorDeResultados?.fetchedObjects else {return []}
        
        return listaDeRepositorios.filter(){$0.usuario!.id == usuario.id}
        
    }
    
    func salvaRepositorio(_ repositorioNaoSalvo:Repositorio, usuario:UsuarioDataModel){
        var repositorioDataModel:NSManagedObject?
        
        guard let id = repositorioNaoSalvo.id else {return}
        
        let repositorios = recuperaRepositorios().filter(){ $0.id == id}
        
        if repositorios.count > 0{
            guard let repositorioEncontrado = repositorios.first else {return}
            repositorioDataModel = repositorioEncontrado
        }else{
            let entidade = NSEntityDescription.entity(forEntityName: "RepositorioDataModel", in: contexto)
            
            repositorioDataModel = NSManagedObject(entity: entidade!, insertInto: contexto)
        }
        
        repositorioDataModel?.setValue(repositorioNaoSalvo.id, forKey: "id")
        repositorioDataModel?.setValue(repositorioNaoSalvo.nomeDoRepositorio, forKey: "nomeDoRepositorio")
        repositorioDataModel?.setValue(repositorioNaoSalvo.dataDeCriacaoDoRepositorio, forKey: "dataDeCriacaoDoRepositorio")
        repositorioDataModel?.setValue(repositorioNaoSalvo.descricaoCompleta, forKey: "descricaoCompleta")
        repositorioDataModel?.setValue(repositorioNaoSalvo.linguagem, forKey: "linguagem")
        repositorioDataModel?.setValue(repositorioNaoSalvo.numeroDeForks, forKey: "numeroDeForks")
        repositorioDataModel?.setValue(repositorioNaoSalvo.numeroDeStars, forKey: "numeroDeStars")
        repositorioDataModel?.setValue(repositorioNaoSalvo.numeroDeIssuesAbertas, forKey: "numeroDeIssuesAbertas")
        repositorioDataModel?.setValue(repositorioNaoSalvo.numeroDeIssuesFechadas, forKey: "numeroDeIssuesFechadas")
        repositorioDataModel?.setValue(repositorioNaoSalvo.urlDoRepositorio, forKey: "urlDoRepositorio")
        repositorioDataModel?.setValue(usuario, forKey: "usuario")
        atualizaContexto()
    }
    
    
    
    func salvarListaDeRepositorios(_ repositoriosNaoSalvos:ListaRepositorio, usuario:UsuarioDataModel){
        for repositorio in repositoriosNaoSalvos{
            salvaRepositorio(repositorio, usuario: usuario)
        }
    }
    
    func deletaRepositorio(repositorio:RepositorioDataModel){
        contexto.delete(repositorio)
        atualizaContexto()
    }
    
    func atualizaContexto(){
        do{
            try contexto.save()
            
        }catch{
            
            print(error.localizedDescription)
        }
    }
    
    
}
