//
//  UsuarioDAOTests.swift
//  mobile-challengerUITests
//
//  Created by Rodrigo Filomeno on 11/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import XCTest
@testable import mobile_challenger

class UsuarioDAOTests: XCTestCase {
    
    var usuarioTesteSemLista: Usuario!
    var qntdUsuariosNoBanco: Int?

    override func setUp() {
        
        self.usuarioTesteSemLista = Usuario()
        self.usuarioTesteSemLista!.id = 123
        self.usuarioTesteSemLista!.nome = "Usuário Teste"
        self.usuarioTesteSemLista!.user = "tester"
        self.qntdUsuariosNoBanco = UsuarioDAO().recuperaUsuarios().count
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        if let usuario = UsuarioDAO().recuperaUsuario(id: 123){
            UsuarioDAO().deletaUsuario(usuario: usuario)
        }
    }

    func testDeveRecuperarUmUsuarioPeloLogin(){
        UsuarioDAO().salvaUsuario(usuarioTesteSemLista)
        let usuario = UsuarioDAO().recuperaUsuario(user: "tester")
        XCTAssertEqual("Usuário Teste", usuario?.nome)
    }
    
    func testDeveRecuperarUmUsuarioPeloId(){
        UsuarioDAO().salvaUsuario(usuarioTesteSemLista)
        let usuarioTeste = UsuarioDAO().recuperaUsuario(id: 123)
        XCTAssertEqual("Usuário Teste", usuarioTeste?.nome)
    }
    
    func testDeveRecuperarListaDeUsuarios(){
        UsuarioDAO().salvaUsuario(usuarioTesteSemLista)
        let listaDeUsuarios = UsuarioDAO().recuperaUsuarios()
        XCTAssertEqual((qntdUsuariosNoBanco! + 1), listaDeUsuarios.count)
        
    }
    
    func testDeveSalvarUmUsuarioSemListaDeRepositorios(){
        
        UsuarioDAO().salvaUsuario(usuarioTesteSemLista)
        guard let recuperaUsuarioTeste = UsuarioDAO().recuperaUsuario(id: 123) else {return}
        XCTAssertEqual("Usuário Teste", recuperaUsuarioTeste.nome)
        
    }
    
    func testDeveApagarUmUsuario(){
        UsuarioDAO().salvaUsuario(usuarioTesteSemLista)
        guard let recuperaUsuarioTeste = UsuarioDAO().recuperaUsuario(id: 123) else {return}
        XCTAssertEqual("Usuário Teste", recuperaUsuarioTeste.nome)
        UsuarioDAO().deletaUsuario(usuario: recuperaUsuarioTeste)
        let recuperaUsuarioApagado = UsuarioDAO().recuperaUsuario(id: 123)
        XCTAssertEqual(nil, recuperaUsuarioApagado)
    }
    
    func testDeveFazerUpdateDeUmUsuario(){
        UsuarioDAO().salvaUsuario(usuarioTesteSemLista)
        guard let recuperaUsuarioTeste = UsuarioDAO().recuperaUsuario(id: 123) else {return}
        var usuarioTesteModificado = ConversorHelper().converteUsuario(recuperaUsuarioTeste)
        usuarioTesteModificado.nome = "Usuário Teste Modificado"
        UsuarioDAO().salvaUsuario(usuarioTesteModificado)
        let listaDeUsuarios = UsuarioDAO().recuperaUsuarios().filter(){$0.id == 123}
        XCTAssertEqual(1, listaDeUsuarios.count)
        XCTAssertEqual("Usuário Teste Modificado", listaDeUsuarios[0].nome)
        
    }
    

}
