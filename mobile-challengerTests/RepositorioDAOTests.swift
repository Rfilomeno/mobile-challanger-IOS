//
//  RepositorioDAOTests.swift
//  mobile-challengerTests
//
//  Created by Rodrigo Filomeno on 11/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import XCTest
@testable import mobile_challenger

class RepositorioDAOTests: XCTestCase {

    
    var usuarioTesteComLista: Usuario!
    var qntdUsuariosNoBanco: Int?
    var listaRepositoriosTeste:ListaRepositorio = []
    
    override func setUp() {
        
        
        self.usuarioTesteComLista = Usuario()
        self.usuarioTesteComLista!.id = 123
        self.usuarioTesteComLista!.nome = "Usuário Teste"
        self.usuarioTesteComLista!.user = "tester"
        self.qntdUsuariosNoBanco = UsuarioDAO().recuperaUsuarios().count
        
        var contador = 0
        while contador < 4 {
            var repositorio = Repositorio()
            repositorio.id = 1 + contador
            repositorio.nomeDoRepositorio = "repositorio \(contador+1)"
            self.listaRepositoriosTeste.append(repositorio)
            contador += 1
        }
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        if let usuario = UsuarioDAO().recuperaUsuario(id: 123){
            UsuarioDAO().deletaUsuario(usuario: usuario)
        }
        
    }

    func testDeveSalvarUmUsuarioComListaDeRepositorios(){
    
        UsuarioDAO().salvaUsuario(usuarioTesteComLista)
        guard let usuario = UsuarioDAO().recuperaUsuario(id: 123) else {return}
        RepositorioDAO().salvarListaDeRepositorios(listaRepositoriosTeste, usuario: usuario)
        XCTAssertEqual("Usuário Teste", usuario.nome)
        let listaRepDoUsuario = RepositorioDAO().recuperaRepositoriosDoUsuario(usuario: usuario)
        XCTAssertEqual(4, listaRepDoUsuario.count)
        guard let repositorioDoUsuario = listaRepDoUsuario.first else {return}
        XCTAssertEqual(usuario, repositorioDoUsuario.usuario)
        
    }
    
    func testDeveDeletarTodosOsRepositoriosDoUsuarioAoDeletarOUsuario(){
        UsuarioDAO().salvaUsuario(usuarioTesteComLista)
        guard let usuario = UsuarioDAO().recuperaUsuario(id: 123) else {return}
        RepositorioDAO().salvarListaDeRepositorios(listaRepositoriosTeste, usuario: usuario)
        let listaRepDoUsuario = RepositorioDAO().recuperaRepositoriosDoUsuario(usuario: usuario)
        XCTAssertEqual(4, listaRepDoUsuario.count)
        UsuarioDAO().deletaUsuario(usuario: usuario)
        let listaRepDoUsuarioApagado = RepositorioDAO().recuperaRepositoriosDoUsuario(usuario: usuario)
        XCTAssertEqual(0, listaRepDoUsuarioApagado.count)
    }

}
