//
//  GitHubApi.swift
//  mobile-challenger
//
//  Created by Rodrigo Filomeno on 31/05/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import UIKit
import Alamofire

class GitHubApi: NSObject {
    
    lazy var urlGitHub: String = {
        guard let urlGitHub = Configuracao().getUrlGitHub() else {return ""}
        return urlGitHub
    }()
    
    func recuperaUsuario(_ usuario:String, completion:@escaping(_ usuarioRetorno:Usuario?)->Void){
        
        Alamofire.request(urlGitHub+usuario,method: .get).responseData { (response) in
            switch response.result {
            case .success:
                if let resposta = response.result.value {
                    let usuarioSerializado = self.serializaUsuario(resposta)
                    if usuarioSerializado?.id == nil{
                        completion(nil)
                    }
                    completion(usuarioSerializado)
                }
                break
            case .failure:
                print(response.error!)
                completion(nil)
                break
            }
        }
    }
    
    
    func recuperaListaUsuario(_ usuario:String,_ page:String = "1",completion:@escaping(_ listaRetorno:ListaRepositorio?)->Void){
        Alamofire.request(urlGitHub+usuario+"/repos?page=\(page)&per_page=100",method: .get).responseData { (response) in
            switch response.result {
            case .success:
                if let resposta = response.result.value {
                    guard let listaDeRepositorios = self.serializaRepositorioUsuario(resposta) else {return}
                    completion(listaDeRepositorios)
                }else{
                    completion(nil)
                }
                break
            case .failure:
                completion(nil)
                break
            }
        }
    }
    
    func serializaUsuario(_ resposta:Data) -> Usuario?{
        do {
            let decoder = JSONDecoder()
            let usuario = try decoder.decode(Usuario.self, from: resposta)
            return usuario
        } catch {
            return nil
        }
    }
    
    func serializaRepositorioUsuario(_ resposta:Data) -> ListaRepositorio? {
        let decoder = JSONDecoder()
        do {
            let listaDeRespositorio = try decoder.decode(ListaRepositorio.self, from: resposta)
            return listaDeRespositorio
        } catch {
            return nil
        }
    }
    
}
