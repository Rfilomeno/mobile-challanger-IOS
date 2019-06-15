//
//  FiltroTests.swift
//  mobile-challengerTests
//
//  Created by Rodrigo Filomeno on 11/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import XCTest
@testable import mobile_challenger

class FiltroTests: XCTestCase {
    
    
    var usuarioTeste: Usuario!
    var qntdUsuariosNoBanco: Int?
    var listaRepositorios:ListaRepositorio = []
    
    override func setUp() {
        
        
        self.usuarioTeste = Usuario()
        self.usuarioTeste!.id = 1
        self.usuarioTeste!.nome = "Usuário Teste"
        self.usuarioTeste!.user = "tester"
        self.qntdUsuariosNoBanco = UsuarioDAO().recuperaUsuarios().count
        
        var contador = 0
        while contador < 4 {
            var repositorio = Repositorio()
            repositorio.id = 1 + contador
            repositorio.nomeDoRepositorio = "repositorio \(contador+1)"
            self.listaRepositorios.append(repositorio)
            contador += 1
        }
        
        UsuarioDAO().salvaUsuario(usuarioTeste)
        let usuario = UsuarioDAO().recuperaUsuario(id: 1)
        guard let user = usuario else {return}
        RepositorioDAO().salvarListaDeRepositorios(listaRepositorios, usuario: user)
        
        var usuarioTeste2 = Usuario()
        usuarioTeste2.id = 2
        usuarioTeste2.nome = "Usuário Teste 2"
        var usuarioTeste3 = Usuario()
        usuarioTeste3.id = 3
        usuarioTeste3.nome = "Usuário Teste 3"
        UsuarioDAO().salvaUsuario(usuarioTeste2)
        UsuarioDAO().salvaUsuario(usuarioTeste3)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        var listaUsuarios = UsuarioDAO().recuperaUsuarios()
        listaUsuarios = Filtro().filtraUsuarios(listaDeUsuario: listaUsuarios, nomeDoUsuario: "Usuário")
        for user in listaUsuarios{
          UsuarioDAO().deletaUsuario(usuario: user)
        }
        
    }

    func testDeveRetornarListaDeUsuariosQuePossuemOTextoFiltradoNoNome(){
        
        var listaDeUsuarios = UsuarioDAO().recuperaUsuarios()
        listaDeUsuarios = Filtro().filtraUsuarios(listaDeUsuario: listaDeUsuarios, nomeDoUsuario: "Usuário")
        XCTAssertEqual(3, listaDeUsuarios.count)
        XCTAssertEqual("Usuário Teste", listaDeUsuarios[0].nome)
        XCTAssertEqual("Usuário Teste 2", listaDeUsuarios[1].nome)
        XCTAssertEqual("Usuário Teste 3", listaDeUsuarios[2].nome)
    }
    
    func testDeveRetornarListaDeRepositoriosQuePossuemOTextoFiltradoNoNome(){
        
        let usuario = UsuarioDAO().recuperaUsuario(id: 1)
        guard let user = usuario else {return}
        let listaDeRepositorios = RepositorioDAO().recuperaRepositoriosDoUsuario(usuario: user)
        XCTAssertEqual(4, listaDeRepositorios.count)
        var lista2 = ConversorHelper().converteListaRepositorio(listaDeRepositorios)
        lista2 = Filtro().filtraRepositorios(listaDeRepositorio: lista2, nomeDoRepositorio: "repo")
        XCTAssertEqual(4, lista2.count)
        lista2 = Filtro().filtraRepositorios(listaDeRepositorio: lista2, nomeDoRepositorio: "2")
        XCTAssertEqual(1, lista2.count)
    }

}
