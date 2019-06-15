//
//  ConversorHelperTests.swift
//  mobile-challengerTests
//
//  Created by Rodrigo Filomeno on 11/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import XCTest
@testable import mobile_challenger

class ConversorHelperTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDeveConverterUserDataModelEmUserStruct(){
        
        let usuario = UsuarioDAO().recuperaUsuario(user: "rfilomeno")
        guard let usuarioDM = usuario else {return}
        let outroDM = UsuarioDataModel()
        XCTAssertTrue(type(of: outroDM) == type(of: usuarioDM))
        let usuarioConvertido = ConversorHelper().converteUsuario(usuarioDM)
        let outroStruct = Usuario()
        XCTAssertTrue(type(of: outroStruct) == type(of: usuarioConvertido))
        XCTAssertEqual(usuarioDM.nome, usuarioConvertido.nome)
    }

    func testDeveConverterListaRepositorioDataModelEmListaRepositorioStruct(){
        let usuario = UsuarioDAO().recuperaUsuario(user: "rfilomeno")
        guard let usuarioTeste = usuario else {return}
        let lista = RepositorioDAO().recuperaRepositoriosDoUsuario(usuario: usuarioTeste)
        let tipoDaLista: Array<RepositorioDataModel> = []
        XCTAssertTrue(type(of: tipoDaLista) == type(of: lista))
        
        let listaConvertida = ConversorHelper().converteListaRepositorio(lista)
        let tipoDaListaConvertida:ListaRepositorio = []
        XCTAssertTrue(type(of: tipoDaListaConvertida) == type(of: listaConvertida))
    }
}
