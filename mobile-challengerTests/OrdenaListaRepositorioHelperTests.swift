//
//  OrdenaListaRepositorioHelperTests.swift
//  mobile-challengerTests
//
//  Created by Rodrigo Filomeno on 11/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import XCTest
@testable import mobile_challenger

class OrdenaListaRepositorioHelperTests: XCTestCase {

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
            repositorio.numeroDeStars = 1 + contador
            repositorio.nomeDoRepositorio = "repositorio \(contador+1)"
            self.listaRepositorios.append(repositorio)
            contador += 1
        }
        
        UsuarioDAO().salvaUsuario(usuarioTeste)
        let usuario = UsuarioDAO().recuperaUsuario(id: 1)
        guard let user = usuario else {return}
        RepositorioDAO().salvarListaDeRepositorios(listaRepositorios, usuario: user)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        if let usuario = UsuarioDAO().recuperaUsuario(id: 1){
            UsuarioDAO().deletaUsuario(usuario: usuario)
        }
    }

    func testDeveOrdenarRepositoriosComBaseNoNumeroDeEstrelas(){
        
        guard let usuario = UsuarioDAO().recuperaUsuario(id: 1) else {return}
        let lista = RepositorioDAO().recuperaRepositoriosDoUsuario(usuario: usuario)
        var lista2 = ConversorHelper().converteListaRepositorio(lista)
        XCTAssertEqual(1, lista2[0].numeroDeStars)
        XCTAssertEqual(2, lista2[1].numeroDeStars)
        XCTAssertEqual(3, lista2[2].numeroDeStars)
        XCTAssertEqual(4, lista2[3].numeroDeStars)
        
        lista2 = OrdenaListaRepositorioHelper().ordena(lista2)
        
        XCTAssertEqual(4, lista2[0].numeroDeStars)
        XCTAssertEqual(3, lista2[1].numeroDeStars)
        XCTAssertEqual(2, lista2[2].numeroDeStars)
        XCTAssertEqual(1, lista2[3].numeroDeStars)
        
        
    }
    
    

}
